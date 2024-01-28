//
//  LoginVC_Extension.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 1/26/24.
//

import UIKit
import SnapKit

extension LoginViewController {
    internal func tryAppleLogin() {
        
    }
    
    internal func tryKakaoLogin() {
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
    
    internal func tryTestLogin() {
        let id = getTextfieldValue(self.testLoginTxf.text)
        
        loginId = id
        loginType = "03"
        
        LoginManager().emailStartFunc(loginId, .test) { result in
            self.view.stopIndicator { stopIndicatorResult in
                if stopIndicatorResult {
                    switch result {
                    case .success(_):
                        self.moveMainVC()
                        // main으로 이동
                        self.coordinator?.choiceVC(.main, isPop: T)
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
    
    internal func checkedAutoLogin() {
        self.isAutoLogin.toggle()
        
        if self.isAutoLogin {
            self.autoLoginImg.image = UIImage(systemName: "square.fill")
//            self.autoLoginImg.image.
        } else {
            self.autoLoginImg.image = UIImage(systemName: "square")
        }
    }
    
    private func moveMainVC () {
        
    }
}
