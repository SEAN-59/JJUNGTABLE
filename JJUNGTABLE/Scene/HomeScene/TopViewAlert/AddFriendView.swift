//
//  AddFriendView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/17/23.
//

import UIKit
import SnapKit

class AddFriendView: BaseView {
//    private let dbManager = DatabaseManager()
    weak var delegate: BaseVCDelegate?
    
    private var myTableId = ""
    private var isFind = F
    private var friendId = ""
    private var friendTableId = ""
    private var getFriendLsit = [String]()
    

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var myIDView: UIView!
    @IBOutlet weak var friendInfoView: UIView!
    
    @IBOutlet weak var friendIDTxf: UITextField!
    
    @IBOutlet weak var myTableIdLbl: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var friendNameLbl: UILabel!
    @IBOutlet weak var friendBirthLbl: UILabel!
    
    @IBOutlet weak var findBtn: UICustomButton!
    @IBOutlet weak var getFriendBtn: UICustomButton!
    
    
    lazy var getFriendView: GetFriendView = {
        let view = GetFriendView()
        return view
    }()
    
    override func viewLoad() {
        self.setLayout()
        
        self.friendIDTxf.delegate = self
//        self.dbManager.delegate = self
    }
    
    func initData(_ myTableId: String, getFriendLsit: [String]) {
        self.myTableId = myTableId
        self.getFriendLsit = getFriendLsit
        let letter = self.myTableId.letter()
        var lbl = ""
        
        for i in 0 ..< letter.count {
            if i != 0 && i%4 == 0 { lbl.append(" ") }
            lbl.append("\(letter[i])")
        }
                
        self.myTableIdLbl.text = "\(lbl)"
        
        if !getFriendLsit.isEmpty {
            self.getFriendBtn.isHidden = false
        }
    }
    
    private func setLayout() {
        self.setChangeView()
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.layer.borderColor = UIColor.brandColor?.cgColor
        self.contentView.layer.borderWidth = 2.0
        
        self.myIDView.layer.cornerRadius = 5.0
        self.friendInfoView.layer.cornerRadius = 5.0
        
        
//        self.friendProfileImg.layer.borderWidth = 1.0
        self.profileImg.layer.cornerRadius = 10.0
        self.profileImg.layer.borderColor = UIColor.black.cgColor
        self.profileImg.backgroundColor = .backColor
        
        self.findBtn.layer.cornerRadius = 10.0
        self.findBtn.layer.borderWidth = 2.0
        
        self.getFriendBtn.isHidden = true
        self.getFriendBtn.layer.cornerRadius = 10.0
        self.getFriendBtn.backgroundColor = .greenColor?.withAlphaComponent(0.3)
        
    }
    
    @IBAction func tapCloseBtn(_ sender: UICustomButton) {
        viewControllers[viewControllers.count-1].popVC()
    }
    
    
    @IBAction func tapGetFriendBtn(_ sender: UICustomButton) {
        self.getFriendView.setData(self.getFriendLsit)
        self.contentView.addSubview(self.getFriendView)
        self.getFriendView.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @IBAction func tapFindBtn(_ sender: UICustomButton) {
        // 초기는 F
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        if self.isFind {
            
            // 이 분기에 들어왔다? 이미 검색은 된거임
            ConnectData().connectFriends { friendData in
                if friendData.isEmpty {
                    // 없는거임
                    // self.friendTableId 의 값은 입력한 값이 들어가게 될것
                    DatabaseManager().createDataBase(.friends, key: loginId , data: [self.myTableId:""]) { dataBase in
                        
                        if let db = dataBase as? DB_SUCCESS {
                            // 만들기 성공
                        }
                        else if let db = dataBase as? DB_FAILURE {
                            // 만들기 실패
                        }
                    }
                }
                else {
                    // 있는거니까
                    let friendList = friendData
                    var isHave = F
                    
                    for f in friendList {
                        if self.friendTableId == f {
                            isHave = T
                        }
                    }
                    
                    if isHave {
                        self.errorAlert(message: "이미 추가된 친구입니다.", isAction: T, isAdd: T)
                    }
                    
                    else {
                        
                        
                        DatabaseManager().updateDataBase(.friends, key: "\(loginId)/\(self.friendTableId)", data: "") { dataBase in
                            if let db = dataBase as? DB_SUCCESS {
                                DatabaseManager().createDataBase(.getFriend, key: self.friendId, data: [self.myTableId:""]) { dataBase in
                                    if let db = dataBase as? DB_SUCCESS {
                                        self.delegate?.reloadVC()
                                        viewControllers[viewControllers.count - 1].popVC()
                                    }
                                    else if let db = dataBase as? DB_FAILURE {
                                        
                                    }
                                }
                                
                            }
                            else if let db = dataBase as? DB_FAILURE {
                                self.errorAlert(message: "추가할 수 없습니다.\n확인 후 다시 시도해주세요.", isAction: F)
                            }
                        }
                        
                    }
                    
                    
                    /*
                         let friendList = data.allKeys
                         var isHave = false
                         for f in friendList {
                             if self.friendTableId == optStr(f) {
                                 isHave = true
                             }
                         }
                         
                         if isHave {
                             makeAlert(viewControllers[viewControllers.count - 1],
                                       title: "안내", message: "이미 추가된 친구입니다.",
                                       actionTitle: ["확인"],
                                       handler: [
                                         { _ in
                                             self.friendIDTxf.text = ""
                                             self.friendIDTxf.isSelected = true
                                             self.isFind = false
                                             self.setChangeView()
                                         }
                                       ])
                         }
                         else {
                             self.dbManager.updateData(.friends, key: "\(loginId)/\(self.friendTableId)",data: "")
                             
                         }
                     */
                }
            }
            
        }
        else {
            // 버튼 누르면 창을 처음 켜게 된거면 여기를 제일 먼저 올 예정
            // self.friendTableId는 처음에 txf값 넣은걸로 저장이 될것
            self.friendTableId = getTextfieldValue(self.friendIDTxf.text)
            if self.friendTableId == self.myTableId {
                self.errorAlert(message: "자신의 ID는 검색할 수 없습니다.\n다시 시도해주세요.", isAction: T)
                
            } else {
                if self.friendTableId.count < 16 {
                    self.errorAlert(message: "ID를 확인 후 다시 시도해주세요.", isAction: T)
                }
                else if self.friendTableId.count == 16 {
                    ConnectData().connectTableId(key: self.friendTableId) { tableData in
                        if tableData != "" {
                            // 성공
                            ConnectData().connectUser(key: self.friendId) { userData in
                                if userData.name == "", userData.birth == "", userData.isSwitch == "", userData.pushToken == "", userData.tableId == "" {
                                    // faiure 부분
                                    self.errorAlert(message: "ID를 확인 후 다시 시도해주세요.", isAction: T)
                                }
                                else {
//                                    [24.01.16] 이거 왜 안들와지냐??
                                    self.friendId = userData.id
                                    self.friendNameLbl.text = userData.name
                                    let date = userData.birth.convertDate()
                                    if date.0 {
                                        self.friendBirthLbl.text = "\(date.1.year)년 \(date.1.month)월 \(date.1.day)일"
                                        self.isFind = true
                                        self.setChangeView()
                                    }
                                }
                            }
                        }
                        else {
                            // 실패
                            self.errorAlert(message: "ID를 확인 후 다시 시도해주세요.", isAction: T)
                        }
                    }
                }
            }
        }
    }
    
    private func setChangeView() {
        if self.isFind {
            self.friendInfoView.isHidden = false
            self.findBtn.setTitle("추가", for: .normal)
        }
        else {
            self.friendInfoView.isHidden = true
            self.findBtn.setTitle("검색", for: .normal)
        }
    }
    
    private func errorAlert(message: String, isAction: Bool, isAdd: Bool = F) {
        makeAlert(viewControllers[viewControllers.count - 1],
                  title: "안내", message: "ID를 확인 후 다시 시도해주세요.",
                  actionTitle: ["확인"],
                  handler: [
                    { _ in
                        if isAction {
                            self.friendIDTxf.text = ""
                            self.friendIDTxf.isSelected = true
                            if isAdd {
                                self.isFind = false
                                self.setChangeView()
                            }
                        }
                    }
                  ])
    }
        
        
}
extension AddFriendView {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = getTextfieldValue(self.friendIDTxf.text)
        printLog(text)
        if text.count > 16 {
            textField.text = "\(text.dropLast(1))"
        }
    }
}
//
//
//extension AddFriendView: DatabaseDelegate {
//    func readData(_ type: DBType, _ result: DB_RESULT_DICT) {
//        @UserDefault(key: "loginId", defaultValue: "") var loginId
//        switch result {
//        case .success(let data):
//            if type == .tableId {
//                let friendId = optStr(data["userId"])
//                self.dbManager.readData(.user, key: "\(friendId)")
//            }
//            
//            else if type == .user {
//                self.friendId  = "\(optStr(data["id"]))"
//                self.friendNameLbl.text = "\(optStr(data["name"]))"
//                let friendBirth = optStr(data["birth"])
//                let date = friendBirth.convertDate()
//                if date.0 {
//                    self.friendBirthLbl.text = "\(date.1.year)년 \(date.1.month)월 \(date.1.day)일"
//                    self.isFind = true
//                    self.setChangeView()
//                }
//            }
//            
//            else if type == .friends {
//                let friendList = data.allKeys
//                var isHave = false
//                for f in friendList {
//                    if self.friendTableId == optStr(f) {
//                        isHave = true
//                    }
//                }
//                
//                if isHave {
//                    makeAlert(viewControllers[viewControllers.count - 1],
//                              title: "안내", message: "이미 추가된 친구입니다.",
//                              actionTitle: ["확인"],
//                              handler: [
//                                { _ in
//                                    self.friendIDTxf.text = ""
//                                    self.friendIDTxf.isSelected = true
//                                    self.isFind = false
//                                    self.setChangeView()
//                                }
//                              ])
//                }
//                else {
//                    self.dbManager.updateData(.friends, key: "\(loginId)/\(self.friendTableId)",data: "")
//                    
//                }
//            }
//            
//            
//        case .failure(_):
//            if type == .tableId || type == .user{
//                makeAlert(viewControllers[viewControllers.count - 1],
//                          title: "안내", message: "ID를 확인 후 다시 시도해주세요.",
//                          actionTitle: ["확인"],
//                          handler: [
//                            { _ in
//                                self.friendIDTxf.text = ""
//                                self.friendIDTxf.isSelected = true
//                            }
//                          ])
//            }
//            else if type == .friends {
//                self.dbManager.createData(.friends, key: loginId, data: ["\(self.friendTableId)":""])
//            }
//        }
//    }
//    func updateData(_ type: DBType, _ result: DB_RESULT_STR) {
//        switch result {
//        case .success(_):
//            switch result {
//            case .success(_):
//                if type == .friends {
//                    @UserDefault(key: "loginId", defaultValue: "") var loginId
//                    self.dbManager.createData(.getFriend, key: "\(self.friendId)",data: ["\(self.myTableId)":""])
//                }
//                
////                else
//                if type == .getFriend {
//                    self.delegate?.reloadVC()
//                    viewControllers[viewControllers.count - 1].popVC()
//                }
//            case .failure(_):
//                break
//            }
//            
//        case .failure(_):
//                makeAlert(viewControllers[viewControllers.count - 1],
//                          title: "안내", message: "추가할 수 없습니다.\n확인 후 다시 시도해주세요.",
//                          actionTitle: ["확인"],
//                          handler: [ { _ in} ])
//        }
//    }
//}
//
//
