//
//  ReservationListTableViewCell.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/30/23.
//

import UIKit

class ReservationListTableViewCell: UITableViewCell {
    weak var delegate: CellDelegate?
    
    private var data: MessageData = .init(messageId: "", title: "", friendId: "", date: "", startTime: "", endTime: "", alarm: "", state: "", location: "", etc: "")
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var shakeView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var underNameView: UIView!
    @IBOutlet weak var underDateView: UIView!
    @IBOutlet weak var underLocationView: UIView!
    
    
    // 만약 배경색을 바꾸게 된다면 얘도 색상 바꿔야 함
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setLayout() {
        self.profileImg.layer.cornerRadius = 10.0
        self.profileImg.layer.borderColor = UIColor.black.cgColor
        self.profileImg.backgroundColor = .backColor
        
        self.underNameView.layer.cornerRadius = 2.0
        self.underDateView.layer.cornerRadius = 2.0
        self.underLocationView.layer.cornerRadius = 2.0
    }
    
    func setData(_ data: MessageData) {
        self.data = data
        self.convertDate()
        self.locationLbl.frame.size.width = 30
        self.locationLbl.text = "\(self.data.location)"
//        self.dbManager.readData(.user, key: self.data.friendId)
        ConnectData().connectUser(key: self.data.friendId) { userData in
            if userData.id == "", userData.name == "", userData.birth == "", userData.isSwitch == "", userData.pushToken == "", userData.tableId == "" {
                // 오류
            }
            else {
                self.nameLbl.text = "\(userData.name)"
                self.toggleIndicator(false)
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
    func selectCell() {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        let date = self.data.date
        
        makeAlert(viewControllers[viewControllers.count - 1],
                  title: "예약 확인", message: "예약을 받아주시겠습니까?",
                  actionTitle: ["확인", "거절", "취소"],
                  style: [.cancel,.destructive,.default],
                  handler: [
                    {_ in
                        
//                        self.dbManager.updateData(.reserveMessage, key: "\(self.data.messageId)/state", data: "Y")
                        DatabaseManager().updateDataBase(.reserveMessage, key: "\(self.data.messageId)/state", data: "Y") { dataBase in
                            if let db = dataBase as? DB_SUCCESS {
                                
                            } 
                            else if let db = dataBase as? DB_FAILURE {
                                
                            }
                        }
//                        self.dbManager.updateData(.reserveList, key: "\(loginId)/\(date)/\(self.data.messageId)", data: "")
                        DatabaseManager().updateDataBase(.reserveMessage, key: "\(loginId)/\(date)/\(self.data.messageId)", data: "") { dataBase in
                            if let db = dataBase as? DB_SUCCESS {
                                
                            }
                            else if let db = dataBase as? DB_FAILURE {
                                
                            }
                        }
//                        self.dbManager.deleteData(.reserveGet, key: "\(loginId)/\(self.data.messageId)")
                        DatabaseManager().deleteDataBase(.reserveGet, key: "\(loginId)/\(self.data.messageId)") { dataBase in
                            if let db = dataBase as? DB_SUCCESS {
                                self.delegate?.doCellSomething()
                            }
                            else if let db = dataBase as? DB_FAILURE {
                                
                            }
                        }
                    },
                    {_ in
//                        self.dbManager.updateData(.reserveMessage, key: "\(self.data.messageId)/state", data: "N")
                        DatabaseManager().updateDataBase(.reserveMessage, key: "\(self.data.messageId)/state", data: "N") { dataBase in
                            if let db = dataBase as? DB_SUCCESS {
                                
                            }
                            else if let db = dataBase as? DB_FAILURE {
                                
                            }
                        }
//                        self.dbManager.deleteData(.reserveGet, key: "\(loginId)/\(self.data.messageId)")
                        DatabaseManager().deleteDataBase(.reserveGet, key: "\(loginId)/\(self.data.messageId)") { dataBase in
                            if let db = dataBase as? DB_SUCCESS {
                                self.delegate?.doCellSomething()
                            }
                            else if let db = dataBase as? DB_FAILURE {
                                
                            }
                        }
                        // 후에 이 작업을 하게 되면 상대방도 거절한게 떠야 하니까 상대방 로드시에
                    },
                    {_ in}
                  ])
    }
    
    private func convertDate() {
        let date = self.data.date.convertDate()
        let time = self.data.startTime.letter() + self.data.endTime.letter()
        var fullDate = ""
        if date.0 {
            fullDate = date.1.convertString("yyyy년 MM월 dd일")
        }
        let timeStr = "\(time[0])\(time[1]):\(time[2])\(time[3]) ~ \(time[4])\(time[5]):\(time[6])\(time[7])"
        
        self.dateLbl.text = "\(fullDate) \(timeStr)"
    }
    
    
}
