//
//  FriendsListView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/30/23.
//

import UIKit
import SnapKit

class FriendsListView: BaseView {
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
    }
    
    func setData(_ count: Int, data: [String] = [""], friendData: [FriendData] = [FriendData]()) {
        self.friendsCount = count
        self.cellIdentifier = self.checkTableCell()
        self.updateTableViewSetting()
        
        if self.friendsCount == 0 {
            self.tableView.reloadData()
        }
        else {
            self.cellDataArray = friendData
            self.cellDataArray = self.cellDataArray.sorted(by: { $0.name < $1.name })
            self.tableView.reloadData()

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
    
    func reloadView() {
        self.tableView.reloadData()
    }
    
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
