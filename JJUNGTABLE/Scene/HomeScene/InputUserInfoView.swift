//
//  InputUserInfoView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/2/23.
//

import UIKit
import SnapKit

class InputUserInfoView: BaseView {
    private var data: UserData = .init(id: "", name: "", birth: "", isSwitch: "", pushToken: "", tableId: "")
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nextBtn: UICustomButton!
    
    @IBOutlet weak var nameTxf: UITextField!
    @IBOutlet weak var emailTxf: UITextField!
    
    @IBOutlet weak var yearTxf: UITextField!
    @IBOutlet weak var monthTxf: UITextField!
    @IBOutlet weak var dayTxf: UITextField!
    
    override func viewLoad() {
        self.setDelegate()
        self.setLayout()
    }
    
    private func setDelegate() {

        [
            self.nameTxf,
            self.emailTxf,
            self.yearTxf,
            self.monthTxf,
            self.dayTxf
        ].forEach{ $0.delegate = self }
    }
    
    private func setLayout() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.borderColor = UIColor.brandColor.cgColor
        
        self.nextBtn.layer.cornerRadius = 5.0
        self.nextBtn.layer.borderWidth = 2.0
        self.nextBtn.layer.borderColor = UIColor.brandColor.cgColor
        
        
    }
    
    @IBAction func tapNextBtn(_ sender: UICustomButton) {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        @UserDefault(key: "loginType", defaultValue: "") var loginType
        @UserDefault(key: "pushToken", defaultValue: "")var pushToken
        @UserDefault(key: "tableId", defaultValue: "")var tableId
        
        var isRequired = false
        
        let name = getTextfieldValue(self.nameTxf.text)
        let year = getTextfieldValue(self.yearTxf.text)
        let month = getTextfieldValue(self.monthTxf.text)
        let day = getTextfieldValue(self.dayTxf.text)
        let email = getTextfieldValue(self.emailTxf.text)
        tableId = DatabaseManager().makeTableID()
        
        if name == "" && year == "" && month == "" && day == "" { isRequired = false }
        else { isRequired = true}
        
        if isRequired {
            // 필수 항목이 다 있을 경우에만 해당 VC를 다운 시키는 작업을 할겁니다.
            let birth = String.combineDate(year: Int(year)!, month: Int(month)!, day: Int(day)!)
            
            let data = [
                "id": loginId,
                "type" : loginType,
                "name" : name,
                "birth" : "\(birth)",
                "switch" : "Y",
                "email" : "\(email)",
                "state" : "",
                "pushToken" : "\(pushToken)",
                "tableId" : "\(tableId)"
            ]
            
            self.data.name = name
            self.data.birth = birth
            self.data.isSwitch = "T"
            self.data.pushToken = pushToken
            self.data.tableId = tableId
            self.data.state = nil
            
            if email != "" { self.data.email = email }
            else { self.data.email = nil }
            
            DatabaseManager().createDataBase(.tableId, key: tableId, data: ["userId":loginId]) { dataBase in
                if dataBase is DB_SUCCESS {
                    DatabaseManager().createDataBase(.user, key: loginId, data: data) { dataBase in
                        if dataBase is DB_SUCCESS {
                            let vc = viewControllers[viewControllers.count - 2] as? MainViewController
                            vc?.userData = self.data
                            vc?.myInfoView.changeView(self.data.name, self.data.state)
                            naviController.popViewController(animated: false)
                        }
                        else if dataBase is DB_FAILURE {
                            self.showError()
                        }
                    }
                }
                else if dataBase is DB_FAILURE {
                    self.showError()
                }
            }
            
            
            
        }
    }
    
    private func showError() {
        makeAlert(viewControllers[viewControllers.count - 1], title: "오류", message: "다시 한 번 시도해주세요.", actionTitle: ["확인"], handler: [{_ in}])
        
    }
    
    
}

extension InputUserInfoView {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        let text = self.getTextfieldValue(textField.text)
        if textField == self.nameTxf {
            printLog("Name")
            
        } else if textField == self.yearTxf {
            printLog("Year")
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = getTextfieldValue(textField.text)
        if textField == self.yearTxf {
            if text == "0" || text.count > 4{
                textField.text = "\(text.dropLast(1))"
            }
        }
        else if textField == self.monthTxf, textField == self.dayTxf {
            if text == "0" || text.count > 3{
                textField.text = "\(text.dropLast(1))"
            }
        }
    }
}
