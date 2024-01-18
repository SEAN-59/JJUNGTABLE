//
//  TodayPlanView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/30/23.
//

import UIKit
import SnapKit

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//#Preview(traits: .portrait, body: {
//    MainViewController()
//})

class TodayPlanView: BaseView {
    static let identifier = "TodayPlanView"
    weak var delegate: BaseVCDelegate?
    
    private let cellSize = 75
    
    private var planCount = 0
    private var cellIdentifier = ""
    
    private var cellDataArray = [MessageData]()
    
    private let TodayPlanTableViewCellNib = UINib(nibName: "TodayPlanTableViewCell", bundle: nil)
    private let emptyTableViewCellNib = UINib(nibName: "EmptyTableViewCell", bundle: nil)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(self.TodayPlanTableViewCellNib,
                                forCellReuseIdentifier: "TodayPlanTableViewCell")
        self.tableView.register(self.emptyTableViewCellNib,
                                forCellReuseIdentifier: "EmptyTableViewCell")

        self.listDataLoad()
    }
    
    func reloadView() {
        self.listDataLoad()
    }
    
    private func listDataLoad() {
        let cellSetting = {
            self.cellIdentifier = self.checkTableCell()
            self.updateTableViewSetting()
            self.tableView.reloadData()
        }
        
        ConnectData().connectReserveList { data in
            if !data.isEmpty {
                if data[0] == DB_EMPTY_ARRAY_KEY {
                    self.planCount = 0
                    cellSetting()
                    // 추가
                    // 성공했으니까 여기서 Completion 반환 코드 작성
                    self.delegate?.sendVCData(identifier: TodayPlanView.identifier, data: "Load")
                }
                else {
                    self.planCount = data.count
                    for i in 0 ..< self.planCount {
                        ConnectData().connectReserveMessage(key: data[i]) { messageData in
                            if messageData.messageId == EMPTY_STR,  messageData.title == EMPTY_STR,
                               messageData.friendId == EMPTY_STR,   messageData.date == EMPTY_STR,
                               messageData.startTime == EMPTY_STR,  messageData.endTime == EMPTY_STR,
                               messageData.alarm == EMPTY_STR,      messageData.state == EMPTY_STR {
                                // 추가
                                // 오류났음
                                // 여기 오류 난거 처리하는거 필요 할듯
                                printLog("TodayPlanView 오류")
                                self.delegate?.sendVCData(identifier: TodayPlanView.identifier, data: "ERROR")
                            }
                            else {
                                self.cellDataArray.append(messageData)
                                if self.planCount == self.cellDataArray.count {
                                    self.sortArray()
                                    cellSetting()
                                    // 추가
                                    // 성공했으니까 여기서 Completion 반환 코드 작성
                                    self.delegate?.sendVCData(identifier: TodayPlanView.identifier, data: "Load")
                                }
                            }
                        }
                    }
                }
            }
            else {
                // 추가
                // 오류
                self.delegate?.sendVCData(identifier: TodayPlanView.identifier, data: "ERROR")
            }
        }
    }
    
    private func sortArray() {
        var array = [(Int,Int)]()
        var dataArray = [MessageData]()
        for i in 0 ..< self.cellDataArray.count {
            let letter = self.cellDataArray[i].startTime.letter()
            let num = Int("\(letter[0])\(letter[1])\(letter[2])\(letter[3])")!
            array.append((num,i))
        }
        
        array = array.sorted(by: {$0.0 < $1.0 })
        
        for i in array {
            dataArray.append(self.cellDataArray[i.1])
        }
        self.cellDataArray = dataArray
    }

}

extension TodayPlanView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.cellIdentifier == "TodayPlanTableViewCell" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(self.cellIdentifier)",
                                                        for: indexPath) as? TodayPlanTableViewCell {
                
                if !self.cellDataArray.isEmpty {
                    cell.toggleIndicator(true)
                    cell.setData(self.cellDataArray[indexPath.row])
                }
                
                cell.selectionStyle = .none
                return cell
            }
        }
        else if self.cellIdentifier == "EmptyTableViewCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(self.cellIdentifier)",
                                                     for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.planCount == 0 {
            return 1
        }
        else {
            return self.planCount
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? TodayPlanTableViewCell {
//            zoomAndOut(cell.alarmBtn, duration: 0.25, x: 1.05, y: 1.05)
//        }
    }
    
    func checkTableCell() -> String {
        if self.planCount == 0 { return "EmptyTableViewCell" }
        else { return "TodayPlanTableViewCell" }
    }
    
    func updateTableViewSetting() {
        if self.planCount == 0 {
            self.tableView.snp.updateConstraints{
                $0.height.equalTo(100)
            }
            self.tableView.isScrollEnabled = false
        }
        else if self.planCount < 3{
            self.tableView.snp.updateConstraints{
                $0.height.equalTo(self.cellSize*self.planCount)
            }
            self.tableView.isScrollEnabled = false
        }
        else {
            self.tableView.snp.updateConstraints{
                $0.height.equalTo(self.cellSize*3)
            }
            self.tableView.isScrollEnabled = true
        }
    }
}
