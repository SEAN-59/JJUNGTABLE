//
//  LoginViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/28/23.
//

import UIKit
import SnapKit

class LoginViewController: BaseVC {
    private var isAutoLogin: Bool = false
    
    @IBOutlet weak var loginAppleBtn: UICustomButton!
    @IBOutlet weak var loginKakaoBtn: UICustomButton!
    @IBOutlet weak var autoLoginImg: UIImageView!
    
    @IBOutlet weak var testLoginView: UIView!
    @IBOutlet weak var loginTestIdBtn: UICustomButton!
    @IBOutlet weak var testIdTxf: UITextField!
    
    @IBOutlet weak var redLineView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
    }
    
    private func setLayout() {
        @UserDefault(key: "testVer", defaultValue: "N") var testVer
        if testVer == "Y" { 
            self.testLoginView.isHidden = false
            self.testLoginView.layer.cornerRadius = 15
            self.loginTestIdBtn.layer.cornerRadius = 15
            self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.testLoginView.bottomAnchor).isActive = true
//            self.testLoginView.
        }
        else { self.testLoginView.isHidden = true }
        
        self.loginAppleBtn.layer.cornerRadius = 15
        self.loginKakaoBtn.layer.cornerRadius = 15
        self.redLineView.layer.cornerRadius = 1
    }
    
    private func moveMainVC() {
        @UserDefault(key: "AutoLogin", defaultValue: "") var autoLogin
        if self.isAutoLogin { autoLogin = "Y" }
        self.popAndPushVC(nextVC: MainViewController(nibName: "MainViewController", bundle: nil))
    }
    
    @IBAction func tapLoginTestIDBtn(_ sender: UICustomButton) {
        let id = getTextfieldValue(self.testIdTxf.text)
        
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        @UserDefault(key: "loginType", defaultValue: "") var loginType
        loginId = id
        loginType = "03"
        
        LoginManager().emailStartFunc(loginId, .test) { result in
            self.view.stopIndicator { stopIndicatorResult in
                if stopIndicatorResult {
                    switch result {
                    case .success(_):
                        self.moveMainVC()
                    case .failure(_):
                        makeAlert(self, title: "안내", message: "로그인 과정에서 문제가 발생하였습니다.\n 다시 시도해주시길 바랍니다.",
                                  actionTitle: ["확인"], handler: [nil])
                    }
                }
            }
        }
        self.view.showIndicator(8, isTimer: true) { result in
            if result {
                makeAlert(self, title: "안내", message: "로그인 과정에서 문제가 발생하였습니다.\n 다시 시도해주시길 바랍니다.",
                          actionTitle: ["확인"], handler: [nil])
            }
        }
    }
    
    @IBAction func tapLoginAppleBtn(_ sender: UICustomButton) {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        @UserDefault(key: "loginType", defaultValue: "") var loginType
        @UserDefault(key: "pushToken", defaultValue: "")var pushToken
        @UserDefault(key: "tableId", defaultValue: "")var tableId
        
        // SEAN: 20231029 - 애플 로그인은 조금 귀찮은디...차차 구현을 해볼까나
        // 회사 코드 땡겨올란다.
        
    }
    
    
    
    
    @IBAction func tapLoginKakaoBtn(_ sender: UICustomButton) {
        LoginManager().startLogin(.kakao,completion: { result in
            self.view.stopIndicator { stopIndicatorResult in
                if stopIndicatorResult {
                    if result {
                        self.moveMainVC()
                    }
                    else{
                        makeAlert(self, title: "안내", message: "로그인 과정에서 문제가 발생하였습니다.\n 다시 시도해주시길 바랍니다.",
                                  actionTitle: ["확인"], handler: [nil])
                    }
                }
            }
        })
        self.view.showIndicator(8, isTimer: true) { result in
            if result {
                makeAlert(self, title: "안내", message: "로그인 과정에서 문제가 발생하였습니다.\n 다시 시도해주시길 바랍니다.",
                          actionTitle: ["확인"], handler: [nil])
            }
        }
        
    }
    
    @IBAction func tapAutoLoginBtn(_ sender: UICustomButton) {
        self.isAutoLogin.toggle()
        
        if self.isAutoLogin {
            self.autoLoginImg.image = UIImage(systemName: "square.fill")
        } else {
            self.autoLoginImg.image = UIImage(systemName: "square")
        }
    }
    
    
    @IBAction func tapExitBtn(_ sender: UICustomButton) {
        self.popVC()
    }
    
    
}


