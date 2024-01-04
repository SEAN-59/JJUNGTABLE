//
//  GetFriendView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/27/23.
//

import UIKit

class GetFriendView: BaseView {
    weak var delegate: BaseVCDelegate?
    
    private let cellSize = 80
    private var getFriendCount = 0
    private var cellIdentifier = ""
    private var cellDataArray = [GetFriendData]()

    private let getFriendTableViewCellNib = UINib(nibName: "GetFriendTableViewCell", bundle: nil)
    
    private let emptyTableViewCellNib = UINib(nibName: "EmptyTableViewCell", bundle: nil)
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewLoad() {
        self.toggleIndicator(isOn: T, inFunc: F)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.contentView.layer.cornerRadius = 20.0
        self.tableView.register(self.getFriendTableViewCellNib,
                                forCellReuseIdentifier: "GetFriendTableViewCell")
        self.tableView.register(self.emptyTableViewCellNib,
                                forCellReuseIdentifier: "EmptyTableViewCell")
           
    }
    private func toggleIndicator(isOn: Bool, inFunc: Bool = F) {
        if isOn {
            showIndicator()
        }
        else {
            stopIndicator()
            if inFunc {
                self.getFriendCount = 0
                self.cellIdentifier = self.checkTableCell()
                self.updateTableViewSetting()
            }
        }
    }
    
    func setData(_ data: [String]) {
        self.getFriendCount = data.count
        for i in data {
            ConnectData().connectTableId(key: i) { tableData in
                if tableData != "" {
                    // 정상 동작
                    ConnectData().connectUser(key: tableData) { userData in
                        if userData.id == "", userData.name == "", userData.birth == "", userData.isSwitch == "", userData.pushToken == "", userData.tableId == "" {
                            // failure
                            self.toggleIndicator(isOn: F, inFunc: T)
                        }
                        else {
                            // 정상 동작
                            self.cellDataArray.append(.init(id: userData.id,
                                                            name: userData.name,
                                                            tableId: userData.tableId))
                            if self.cellDataArray.count == self.getFriendCount {
                                self.cellIdentifier = self.checkTableCell()
                                self.cellDataArray = self.cellDataArray.sorted(by: { $0.name < $1.name })
                                self.updateTableViewSetting()
                                self.tableView.reloadData()
                                self.toggleIndicator(isOn: F, inFunc: F)
                            }
                        }
                    }
                }
                else {
                    // failure
                    self.toggleIndicator(isOn: F, inFunc: T)
                    
                    
                }
            }
//            self.dbManager.readData(.tableId, key: i)
        }
    }
    
    @IBAction func tapExitBtn(_ sender: UICustomButton) {
        viewControllers[viewControllers.count-1].popVC()
    }
}

extension GetFriendView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.cellIdentifier == "GetFriendTableViewCell" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(self.cellIdentifier)",
                                                        for: indexPath) as? GetFriendTableViewCell {
                
                if !self.cellDataArray.isEmpty {
//                    cell.toggleIndicator(true)
                    cell.delegate = self
                    cell.setData(self.cellDataArray[indexPath.row], index: indexPath)
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
//        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getFriendCount == 0 ? 1 : self.getFriendCount
    }
    
    func checkTableCell() -> String {
        if self.getFriendCount == 0 { return "EmptyTableViewCell" }
        else { return "GetFriendTableViewCell" }
    }
    
    func updateTableViewSetting() {
        
        if self.getFriendCount == 0 {
            self.tableView.snp.updateConstraints{
                $0.height.equalTo(100)
            }
            self.tableView.isScrollEnabled = false
        }
        else {
            self.tableView.snp.updateConstraints{
                $0.height.equalTo(self.cellSize*self.getFriendCount)
            }
            self.tableView.isScrollEnabled = false
        }
    }
}

extension GetFriendView: CellDelegate {
    func sendCellData(_ data: Any) {
        if let indexPath = data as? IndexPath {
            self.getFriendCount = self.getFriendCount - 1
            self.cellIdentifier = self.checkTableCell()
            self.updateTableViewSetting()
            self.cellDataArray.remove(at: indexPath.row)
            if self.getFriendCount == 0 {
                self.tableView.reloadData()
            }
            else {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            self.delegate?.reloadVC()
        }
    }
}

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//#Preview(traits: .portrait, body: {
//    GetFriendView()
//})
