//
//  ReservationListView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/30/23.
//

import UIKit
import SnapKit

class ReservationListView: BaseView {
    static var identifier = "ReservationListView"
    weak var delegate: BaseVCDelegate?
    
    private let cellSize = 110
    
    private var isDateCheck: Bool = F
    
    private var listCount = 0
    private var cellIdentifier = "EmptyTableViewCell"
    
    private var cellDataArray = [MessageData]()
    
    private let reservationListTableViewCellNib = UINib(nibName: "ReservationListTableViewCell", bundle: nil)
    private let emptyTableViewCellNib = UINib(nibName: "EmptyTableViewCell", bundle: nil)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(self.reservationListTableViewCellNib,
                                forCellReuseIdentifier: "ReservationListTableViewCell")
        self.tableView.register(self.emptyTableViewCellNib,
                                forCellReuseIdentifier: "EmptyTableViewCell")
        
        self.listDataLoad()
    }
    
    func reloadView() {
        self.listDataLoad()
    }
    
    private func listDataLoad() {
        //
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        
        let cellSetting = {
            self.cellIdentifier = self.checkTableCell()
            self.updateTableViewSetting()
            self.tableView.reloadData()
            self.delegate?.sendVCData(identifier: ReservationListView.identifier, data: "Load")
        }
        
        
        let updateData = {
            if self.listCount == self.cellDataArray.count {
                var result = [MessageData]()
                for i in self.cellDataArray {
                    let date = ("\(Date().convertString().stringToInt())", "\(i.date.stringToInt())")
                    if date.0 > date.1 {
                        // 약속 데이터보다 오늘 날짜가 더 최신일때 근데 아직 수락 안했다? 거절이지
                        DatabaseManager().updateDataBase(.refuseMessage, key: i.friendId, data: [loginId:""]) { dataBase in
                            if dataBase is DB_SUCCESS { }
                            else if dataBase is DB_FAILURE {}
                        }
                        // 거절 했으니깐 이제 받은 곳에서 지워야징
                        DatabaseManager().deleteDataBase(.reserveGet, key: "\(loginId)/\(i.messageId)") { dataBase in
                            if let db = dataBase as? DB_SUCCESS {
                                for i in 0 ..< self.cellDataArray.count {
                                    if db.key == "\(loginId)/\(self.cellDataArray[i].messageId)" {
                                        // 해당 지운걸 View에서 보이기 위한 곳에서도 날려야지
                                        self.cellDataArray.remove(at: i)
                                        // for 문 탈출
                                        break
                                    }
                                }
                            }
                        }
                    }
                    else {
                        // 아직 예약 안 지났을때
                        result.append(i)
                    }
                    self.cellDataArray = result
                    self.listCount = self.cellDataArray.count
                }
                
                self.sortArray()
                cellSetting()
            }
        }
        
        // 이건 messageId 들의 집합
        self.cellDataArray = []
        ConnectData().connectReserveGet { data in
            if !data.isEmpty {
                if data[0] == DB_EMPTY_ARRAY_KEY {
                    //                        self.reservationListView.setData(0)
                    self.listCount = 0
                    cellSetting()
                }
                else {
                    self.listCount = data.count
                    for i in data {
                        ConnectData().connectReserveMessage(key: i) { messageData in
                            if messageData.messageId == EMPTY_STR, messageData.title == EMPTY_STR, messageData.friendId == EMPTY_STR, messageData.date == EMPTY_STR,
                               messageData.startTime == EMPTY_STR, messageData.endTime == EMPTY_STR,
                               messageData.alarm == EMPTY_STR, messageData.state == EMPTY_STR {
                                // optinal 아닌 값들이 빈값이 넘어 왔다? == 오류
                                self.delegate?.sendVCData(identifier: ReservationListView.identifier, data: "ERROR")
                            }
                            else {
                                // 정상 동작
                                // 여기서 부터 하면 됩니다. 1.4
                                // 친구가 탈퇴를 했나 안했나
                                DatabaseManager().readDataBase(.user, key: messageData.friendId) { dataBase in
                                    if dataBase is DB_SUCCESS {
                                        // 여기 들왔다는건 친구가 있다는 거지 그러니까 저장하는 배열에 메세지 데이터 저장하기
                                        self.cellDataArray.append(messageData)
                                        // 그리고 이제 모든 배열에 모든 정보가 들왔는지 카운팅하는거
                                        updateData()
//                                        self.updateData()
                                        
                                    }
                                    else if let db = dataBase as? DB_FAILURE {
                                        self.listCount -= 1
                                        
                                        for i in self.cellDataArray {
                                            if i.friendId == db.key {
                                                // 삭제 해야 할건 reserveGet, reserveMessage 2군데를 진행해야 함
                                                //                                        self.dbManager.deleteData(.reserveGet, key: "\(loginId)/\(i.messageId)")
                                                DatabaseManager().deleteDataBase(.reserveGet, key: "\(loginId)/\(i.messageId)") { dataBase in
                                                    if let db = dataBase as? DB_SUCCESS {
                                                        for i in 0 ..< self.cellDataArray.count {
                                                            if db.key == "\(loginId)/\(self.cellDataArray[i].messageId)" {
                                                                self.cellDataArray.remove(at: i)
//                                                                self.updateData()
                                                                updateData()
                                                                break
                                                            }
                                                        }
                                                    }
                                                    else if dataBase is DB_FAILURE {
                                                        // 삭제 실패 했다고 문제가 있을 필요는 없긴 하지..
                                                        //                                                            self.delegate?.sendVCData(identifier: TodayPlanView.identifier, data: "ERROR")
                                                    }
                                                }
                                                DatabaseManager().deleteDataBase(.reserveMessage, key: i.messageId) { _ in }
                                            }
                                        }
                                    }
                                    
                                }
                                
                                
                            }
                            
                        }
                    }
                    //                        self.reservationListView.setData(data.count, data: data)
                }
            }
            else {
                // 추가
                // 오류
                //                self.dataCheckCount.1 -= 1
                self.delegate?.sendVCData(identifier: ReservationListView.identifier, data: "ERROR")
            }
        }
    }
    /*
    func setData(_ count: Int, data: [String] = [] ) {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        self.listCount = count
        
        if self.listCount == 0 {
            self.cellIdentifier = self.checkTableCell()
            self.updateTableViewSetting()
            self.tableView.reloadData()
        }
        else {
            for i in data {
//                self.dbManager.readData(.reserveMessage, key: i)
                ConnectData().connectReserveMessage(key: i) { messageData in
                    if messageData.messageId == EMPTY_STR, messageData.title == EMPTY_STR, messageData.friendId == EMPTY_STR, messageData.date == EMPTY_STR,
                       messageData.startTime == EMPTY_STR, messageData.endTime == EMPTY_STR,
                       messageData.alarm == EMPTY_STR, messageData.state == EMPTY_STR {
                        // optinal 아닌 값들이 빈값이 넘어 왔다? == 오류
                        self.setData(0)
                    }
                    else {
                        // 정상 동작
                        // 여기서 부터 하면 됩니다. 1.4
//                        self.dbManager.readData(.user, key: "\(friendId)")
                        // 친구가 탈퇴를 했나 안했나
                        DatabaseManager().readDataBase(.user, key: messageData.friendId) { dataBase in
                            if let db = dataBase as? DB_SUCCESS {
                                self.cellDataArray.append(messageData)
                                self.updateData()
                            } 
                            else if let db = dataBase as? DB_FAILURE {
                                self.listCount -= 1
                                
                                for i in self.cellDataArray {
                                    if i.friendId == db.key {
                                        // 삭제 해야 할건 reserveGet, reserveMessage 2군데를 진행해야 함
//                                        self.dbManager.deleteData(.reserveGet, key: "\(loginId)/\(i.messageId)")
                                        DatabaseManager().deleteDataBase(.reserveGet, key: "\(loginId)/\(i.messageId)") { dataBase in
                                            if let db = dataBase as? DB_SUCCESS {
                                                for i in 0 ..< self.cellDataArray.count {
                                                    if db.key == "\(loginId)/\(self.cellDataArray[i].messageId)" {
                                                        self.cellDataArray.remove(at: i)
                                                        self.updateData()
                                                        break
                                                    }
                                                }
                                            }
                                            else if let db = dataBase as? DB_FAILURE {
                                                
                                            }
                                        }
//                                        self.dbManager.deleteData(.reserveMessage, key: "\(i.messageId)")
                                        DatabaseManager().deleteDataBase(.reserveMessage, key: i.messageId) { _ in }
                                    }
                                }
                            }

                        }
                        
                        
                    }
                    
                }
                
            }
            
        }
        
    }
     */
    
    private func sortArray() {
        // (date, time, index)
        var array = [(Int, Int, Int)]()
        var dataArray = [MessageData]()
        for i in 0 ..< self.cellDataArray.count {
            let letter = self.cellDataArray[i].startTime.letter()
            let date = Int("\(self.cellDataArray[i].date)")!
            let time = Int("\(letter[0])\(letter[1])\(letter[2])\(letter[3])")!
            array.append((date, time, i))
        }
        
        array = array.sorted(by: {
            if $0.0 == $1.0 {
                return $0.1 < $1.1
            } else {
                return $0.0 < $1.0
            }
        })
        
        for i in array {
            dataArray.append(self.cellDataArray[i.2])
        }
        self.cellDataArray = dataArray
    }
    
    
}


extension ReservationListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.cellIdentifier == "ReservationListTableViewCell" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(self.cellIdentifier)",
                                                        for: indexPath) as? ReservationListTableViewCell {
                
                if !self.cellDataArray.isEmpty {
                    cell.toggleIndicator(true)
                    cell.setData(self.cellDataArray[indexPath.row])
                }
                cell.delegate = self
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
        if self.listCount == 0 { return 1 }
        else { return self.listCount }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? ReservationListTableViewCell {
            zoomAndOut(cell.shakeView, duration: 0.25, x: 1.05, y: 1.05) {
                printLog("Reservation END")
                cell.selectCell()
            }
        }
    }
    
    func checkTableCell() -> String {
        if self.listCount == 0 { return "EmptyTableViewCell" }
        else { return "ReservationListTableViewCell" }
    }
    
    func updateTableViewSetting() {
        self.cellIdentifier = self.checkTableCell()
        if self.listCount == 0 {
            self.tableView.snp.updateConstraints {
                $0.height.equalTo(100)
            }
            self.tableView.isScrollEnabled = false
        }
        else if self.listCount < 5 {
            self.tableView.snp.updateConstraints {
                $0.height.equalTo(self.cellSize * self.listCount)
            }
            self.tableView.isScrollEnabled = false
        }
        else {
            self.tableView.snp.updateConstraints {
                $0.height.equalTo(self.cellSize * 5)
            }
            self.tableView.isScrollEnabled = true
        }
    }
    
//    private func updateData() {
//        if self.listCount == 0 {
//            self.setData(0)
//        }
//        else if self.listCount == self.cellDataArray.count {
//            self.checkOverDate()
//            
//            self.sortArray()
//            self.updateTableViewSetting()
//            
//            self.tableView.reloadData()
//        }
//    }
    
//    private func checkOverDate() {
//        @UserDefault(key: "loginId", defaultValue: "") var loginId
//        var result = [MessageData]()
//        for i in self.cellDataArray {
//            let date = (Int("\(Date().convertString())")!,Int("\(i.date)")!)
//            // 예약 시간이 지났음 == 거절
//            if date.0 > date.1 {
//                // 거절 테이블에 올리고, get에서 삭제
//                DatabaseManager().updateDataBase(.refuseMessage, key: i.friendId, data: ["\(loginId)":""]) { dataBase in
//                    if let db = dataBase as? DB_SUCCESS {
//                        
//                    } 
//                    else if let db = dataBase as? DB_FAILURE {
//                        
//                    }
//                }
////                self.dbManager.createData(.refuseMessage, key: "\(i.friendId)", data: ["\(loginId)":""])
//                // 이거 이렇게 하면 이 함수 또 타게 될거 같은데....
//                DatabaseManager().deleteDataBase(.reserveGet, key: "\(loginId)/\(i.messageId)") { dataBase in
//                    if let db = dataBase as? DB_SUCCESS {
//                        for i in 0 ..< self.cellDataArray.count {
//                            if db.key == "\(loginId)/\(self.cellDataArray[i].messageId)" {
//                                self.cellDataArray.remove(at: i)
//                                self.updateData()
//                                break
//                            }
//                        }
//                    }
//                    else if let db = dataBase as? DB_FAILURE {
//                        
//                    }
//                }
////                self.dbManager.deleteData(.reserveGet, key: "\(loginId)/\(i.messageId)")
//            }
//            // 아직 예약 안지남
//            else { result.append(i) }
//        }
//        self.cellDataArray = result
//        self.listCount = self.cellDataArray.count
//    }
}

extension ReservationListView: CellDelegate {
    func sendCellData(_ data: Any) {
        if let data = data as? [String: String] {
            self.delegate?.sendVCData(identifier: ReservationListView.identifier, data: data)
        }
    }
    func doCellSomething() {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
//        self.cellDataArray = []
//        self.dbManager.readData(.reserveGet, key: "\(loginId)")
//        ConnectData().connectReserveGet { getData in
//            if getData.isEmpty {
////                self.setData(0)
//                self.listDataLoad()
//            }
//            else {
//                self.listDataLoad()
////                self.setData(getData.count, data: getData)
//            }
//        }
        self.listDataLoad()
        self.delegate?.reloadVC()
    }
}
