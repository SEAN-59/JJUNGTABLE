//
//  ChangeStateView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/9/23
//

import UIKit
import SnapKit

class ChangeStateView: BaseView {
    private var state: String = ""

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stateTxf: UITextField!
    @IBOutlet weak var confirmBtn: UICustomButton!
    
    override func viewLoad() {
        self.stateTxf.delegate = self
        
        self.confirmBtn.layer.cornerRadius = 20
        self.confirmBtn.layer.borderWidth = 1
        self.confirmBtn.layer.borderColor = UIColor.brandColor?.cgColor
        self.contentView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        self.contentView.layer.cornerRadius = 25
        self.stateTxf.becomeFirstResponder()
        
    }
    
    @IBAction func tapConfirmBtn(_ sender: UICustomButton) {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        let text = getTextfieldValue(self.stateTxf.text)
        self.state = text
        DatabaseManager().updateDataBase(.user, key: "\(loginId)/state", data: text) { dataBase in
            if let db = dataBase as? DB_SUCCESS {
                let vc = viewControllers[viewControllers.count - 1] as? MainViewController
                vc?.userData.state = self.state
                
                if let name = vc?.userData.name {
                    vc?.myInfoView.changeView(name, self.state)
                }
                
                naviController.popViewController(animated: false)
            }
            else if let db = dataBase as? DB_FAILURE {
                makeAlert(viewControllers[viewControllers.count - 1], title: "오류", message: "다시 한 번 시도해주세요.", actionTitle: ["확인"], handler: [{_ in}])
            }
        }
    }
    
    @IBAction func tapCloseBtn(_ sender: UICustomButton) {
        viewControllers[viewControllers.count-1].popVC()
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        false
    }
}

extension ChangeStateView {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = getTextfieldValue(self.stateTxf.text)
        printLog(text)
        if text.count > 20 {
            textField.text = "\(text.dropLast(1))"
        }
    }
}

extension ChangeStateView: DatabaseDelegate {
    func updateData(_ type: DBType, _ result: Result<String, DB_ERROR>) {
        switch result {
        case .success(let success):
            printLog("\(self) : \(success)")
            let vc = viewControllers[viewControllers.count - 1] as? MainViewController
            vc?.userData.state = self.state
            
            if let name = vc?.userData.name {
                vc?.myInfoView.changeView(name, self.state)
            }
            
            naviController.popViewController(animated: false)
        case .failure(let failure):
            printLog("\(self) : \(failure)")
            makeAlert(viewControllers[viewControllers.count - 1], title: "오류", message: "다시 한 번 시도해주세요.", actionTitle: ["확인"], handler: [{_ in}])
        }
    }
    
}
