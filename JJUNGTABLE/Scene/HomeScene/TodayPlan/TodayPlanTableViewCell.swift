//
//  TodayPlanTableViewCell.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/30/23.
//

import UIKit
import SnapKit

class TodayPlanTableViewCell: UITableViewCell {
    private var data: MessageData = .init(messageId: "", title: "", friendId: "", date: "", startTime: "", endTime: "", alarm: "Y", state: "", location: "", etc: "")
    
//    private var isFlag: Bool = false

    // 만약 배경색을 바꾸게 된다면 얘도 색상 바꿔야 함
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    @IBOutlet weak var alarmView: UIView!
    
    @IBOutlet weak var alarmBtn: UICustomButton!
    @IBOutlet weak var friendNameLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var minuteLbl: UILabel!
    @IBOutlet weak var LocationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tapAlarmBtn(_ sender: UICustomButton) {
        shakeView(self.alarmView, duration: 0.25, rotation: 0.25) {
            self.toggleAlarm(true)
        }
    }
    
    func setData(_ data: MessageData) {
        printLog("Data:\(data)")
        self.data = data
        self.LocationLbl.text = self.data.location
        
        let timeList = self.data.startTime.letter()
        self.hourLbl.text = "\(timeList[0])\(timeList[1])"
        self.minuteLbl.text = "\(timeList[2])\(timeList[3])"

        ConnectData().connectUser(key: self.data.friendId) { userData in
            self.friendNameLbl.text = userData.name
            self.toggleAlarm()
            self.toggleIndicator(F)
        }
        
    }
    
    private func toggleAlarm(_ update: Bool = false) {
        if self.data.alarm == "Y" {
            self.data.alarm = "N"
            self.alarmBtn.setImage(UIImage(systemName: "bell.and.waves.left.and.right.fill"), for: .normal)
            self.alarmBtn.configuration?.baseForegroundColor = .accentColor
            
            if update {
                DatabaseManager().updateDataBase(.reserveMessage, key: "\(self.data.messageId)/alarm", data: "N") { dataBase in
                    if let db = dataBase as? DB_SUCCESS {
                        
                    }
                    else if let db = dataBase as? DB_FAILURE {
                        
                    }
                }
            }
        }
        else if data.alarm == "N" {
            self.data.alarm = "Y"
            self.alarmBtn.setImage(UIImage(systemName: "bell.slash.fill"), for: .normal)
            self.alarmBtn.configuration?.baseForegroundColor = .systemGray6
            
            if update {
                DatabaseManager().updateDataBase(.reserveMessage, key: "\(self.data.messageId)/alarm", data: "Y") { dataBase in
                    if let db = dataBase as? DB_SUCCESS {
                        
                    }
                    else if let db = dataBase as? DB_FAILURE {
                        
                    }
                }
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
    
}
extension TodayPlanTableViewCell: DatabaseDelegate {
    func readData(_ type: DBType, _ result: DB_RESULT_DICT) {
        switch result {
        case .success(let data):
            if type == .user {
                printLog(optStr(data["name"]))
                self.friendNameLbl.text = optStr(data["name"])
                self.toggleAlarm()
                self.toggleIndicator(false)
                
            }
        case .failure(_):
//            printLog(optStr(data["name"]))
            break
        }
    }
    
    func updateData(_ type: DBType, _ result: DB_RESULT_STR) {
        printLog(result)
    }
}
