//
//  AppUserIDSettingView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/11/23.
//

import UIKit

class AppUserIDSettingView: BaseView {
    private var deleteCnt = 0
    
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    @IBOutlet weak var backView: UIView!
    
    
    override func viewLoad() {
        @UserDefault(key: "AutoLogin", defaultValue: "") var autoLogin
        
        self.backView.layer.cornerRadius = 25
        self.backView.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
        if autoLogin == "Y" { self.autoLoginSwitch.isOn = T }
        else { self.autoLoginSwitch.isOn = F }
    }

    @IBAction func toggleAutoLoginSwitch(_ sender: UISwitch) {
        @UserDefault(key: "AutoLogin", defaultValue: "") var autoLogin
        if self.autoLoginSwitch.isOn { autoLogin = "Y" }
        else { autoLogin = "N" }
    }
    
    @IBAction func tapAppUserIDSettingBtn(_ sender: UICustomButton) {
        if sender.tag == 0 {
            LoginManager().logout()
            // 로그아웃 버튼
        }
        else if sender.tag == 1 {
            // 계정 탈퇴 버튼
            LoginManager().deleteLoginID(completion: { result in
                switch result {
                case .success(_):
//                    // 계정 탈퇴하면 version, reserveMessage 빼곤 다 날리면 됨
                    ConnectData().allClearData { result in
                        if result {LoginManager().logout()}
                    }
                case .failure(_):
                    break
                }
            })
        }
    }
}

