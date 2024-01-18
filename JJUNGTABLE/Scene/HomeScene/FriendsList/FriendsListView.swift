//
//  FriendsListView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/30/23.
//

import UIKit
import SnapKit

class FriendsListView: BaseView {
    static let identifier = "FriendsListView"
    weak var delegate: BaseVCDelegate?
    
    private let cellSize = 105
    
    private var friendsCount = 0
    private var cellIdentifier = ""
    
    private var cellDataArray = [FriendData]()
    private var idList = [String]()
    
    private let FriendsListTableViewCellNib = UINib(nibName: "FriendsListTableViewCell", bundle: nil)
    private let emptyTableViewCellNib = UINib(nibName: "EmptyTableViewCell", bundle: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    // 만약 배경색을 바꾸게 된다면 얘도 색상 바꿔야 함
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    override func viewLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(self.FriendsListTableViewCellNib,
                                forCellReuseIdentifier: "FriendsListTableViewCell")
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
        
        ConnectData().connectFriends { friendsData in
            if !friendsData.isEmpty {
                if friendsData[0] == DB_EMPTY_ARRAY_KEY {
                    // 친구가 한 명도 없는것
                    self.friendsCount = 0
                    cellSetting()
                    self.delegate?.sendVCData(identifier: FriendsListView.identifier, data: "Load")
                }
                else {
                    // 친구가 있음
                    var friendCount = friendsData.count > 0 ? friendsData.count : 0
                    var friendList = [String]()
                    
                    for i in 0 ..< friendCount {
                        // 이제 그 친구가 진짜 있는 친구인지 확인하기
                        ConnectData().connectTableId(key: friendsData[i]) { tableData in
                            if tableData == "" { 
                                // 없다? 탈퇴 한것
                                DatabaseManager().deleteDataBase(.friends, key: friendsData[i]) { dataBase in
                                    if dataBase is DB_SUCCESS {
                                        // 삭제 시킨것
                                        friendCount -= 1
                                    }
                                    else if dataBase is DB_FAILURE {
                                        self.delegate?.sendVCData(identifier: FriendsListView.identifier, data: "ERROR")
                                        // 삭제가 안된다? 오류가 있는건데 이건 어떻게 처리를 해야하나...
                                    }
                                }
                            }
                            else {
                                // 탈퇴 안했으니 제대로 처리 해야겠지?
                                friendList.append(tableData)
                                if friendList.count == friendCount {
                                    var cellDataList = [FriendData]()
                                    for i in 0 ..< friendList.count{
                                        ConnectData().connectUser(key: friendList[i]) { data in
                                            // 오류로 친구가 등록되있고 데이터도 있는데 값을 못받아오면 에러 > -= 1
                                            if data.name == "", data.birth == "", data.isSwitch == "", data.pushToken == "", data.tableId == "" {
                                                // faiure 부분
//                                                self.dataCheckCount.1 -= 1
                                                self.delegate?.sendVCData(identifier: FriendsListView.identifier, data: "ERROR")
                                            }
                                            // 정상적으로 cell 데이터를 모으는 작업 > 다 모아지면 setData 해주고 addLoadCount() 해줌
                                            else {
                                                let friendData: FriendData = .init(id: friendList[i],
                                                                                   name: data.name,
                                                                                   isSwitch: data.isSwitch,
                                                                                   tableId: data.tableId,
                                                                                   state: data.state)
                                                cellDataList.append(friendData)
                                                if friendList.count == cellDataList.count {
                                                    // 다 불러와졌을때나 여기 들오는것
//                                                    self.friendsListView.setData(cellDataList.count,friendData: cellDataList)
                                                    self.friendsCount = cellDataList.count
                                                    self.cellDataArray = cellDataList
                                                    self.cellDataArray = self.cellDataArray.sorted(by: { $0.name < $1.name })
                                                    cellSetting()
                                                    self.delegate?.sendVCData(identifier: FriendsListView.identifier, data: "Load")
                                                    // 정상 작동
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                // 친구 데이터가 안불러와짐
                self.delegate?.sendVCData(identifier: FriendsListView.identifier, data: "ERROR")
            }
            
        }
        
    }
    
    
    func toggleIndicator(_ flag: Bool) {
        if flag {
            self.addSubview(self.whiteView)
            self.whiteView.snp.updateConstraints{
                $0.edges.equalToSuperview()
            }
            self.showIndicator(removeBack: true)
        }
        else {
            self.whiteView.removeFromSuperview()
            self.stopIndicator()
        }
    }
    
//    func reloadView() {
//        self.tableView.reloadData()
//    }
    
}
extension FriendsListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.cellIdentifier == "FriendsListTableViewCell" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(self.cellIdentifier)",
                                                        for: indexPath) as? FriendsListTableViewCell {
                
                if !self.cellDataArray.isEmpty {
                    cell.toggleIndicator(true)
                    cell.setData(self.cellDataArray[indexPath.row])
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
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
        return self.friendsCount == 0 ? 1 : self.friendsCount
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.cellIdentifier == "EmptyTableViewCell" {
            return F
        }
        else {
            return T
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        printLog("DELETE?")
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        
        if editingStyle == .delete {
            self.friendsCount = self.friendsCount - 1
            self.cellIdentifier = self.checkTableCell()
            self.updateTableViewSetting()
            let friendId = cellDataArray[indexPath.row].tableId
            self.cellDataArray.remove(at: indexPath.row)
            
            // [THINKING] ERROR HANDLING
            DatabaseManager().deleteDataBase(.friends, key: friendId) { dataBase in
                if let db = dataBase as? DB_SUCCESS {
                    // 정상 삭제 됨
                }
                else if let db = dataBase as? DB_FAILURE {
                    // 비정상 오류
                }
            }
            
            if self.friendsCount == 0 { tableView.reloadData() }
            else { tableView.deleteRows(at: [indexPath], with: .fade) }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? TodayPlanTableViewCell {
//            zoomAndOut(cell.alarmBtn, duration: 0.25, x: 1.05, y: 1.05)
//        }
    }
    
    func checkTableCell() -> String {
        if self.friendsCount == 0 { return "EmptyTableViewCell" }
        else { return "FriendsListTableViewCell" }
    }
    
    func updateTableViewSetting() {
        if self.friendsCount == 0 {
            self.tableView.snp.updateConstraints{
                $0.height.equalTo(100)
            }
            self.tableView.isScrollEnabled = false
        }
        else {
            self.tableView.snp.updateConstraints{
                $0.height.equalTo(self.cellSize * self.friendsCount)
            }
            self.tableView.isScrollEnabled = false
        }
    }
}

extension FriendsListView: CellDelegate {
    func sendCellData(_ data: Any) {
        if let data = data as? FriendPopUpViewController {
            self.delegate?.sendVCData(identifier: FriendsListView.identifier, data: data)
        }
    }
}
