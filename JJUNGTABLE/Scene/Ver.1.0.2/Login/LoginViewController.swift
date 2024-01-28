//
//  LoginViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/28/23.
//

import UIKit
import SnapKit

class LoginViewController: BaseVC {
    weak var coordinator: LoginCoordinator?
    internal var isAutoLogin: Bool = false
    
    @UserDefault(key: "loginId", defaultValue: "") var loginId
    @UserDefault(key: "loginType", defaultValue: "") var loginType
    
    private lazy var titleView: UIView = {
        let view = UIView()
        let titleLbl = makeLabel(text: "로그인", font: font_NPS(.regular,28)
        )
        let separateView = makeSeparateView(color: .jjungColor)
        [
            titleLbl,
            separateView
        ].forEach { view.addSubview($0) }
        
        titleLbl.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        separateView.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLbl.snp.bottom).inset(-5)
            $0.leading.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        return view
    }()
    
    
    private lazy var appleLoginBtn: UICustomButton = {
        let button = makeButton(text: "Apple 계정으로 시작하기",
                                font: font_NPS(.regular, 16), fontColor: .white,
                                backColor: .black,
                                animate: (T,F))
        
        button.layer.cornerRadius = 15
        
        button.tag = 0
        return button
    }()
    
    private lazy var kakaoLoginBtn: UICustomButton = {
        let button = makeButton(text: "Kakao 계정으로 시작하기",
                             font: font_NPS(.regular, 16),
                             backColor: .kakaoColor,
                             animate: (T,F))
        
        button.layer.cornerRadius = 15
        button.tag = 1
        return button
    }()
    
    private lazy var appleLogoImg: UIImageView = {
        let img = makeImgView(systemName: "applelogo",
                          pallete: [.white],
                          tint: .white)
        return img
    }()
    
    private lazy var kakaoLogoImg: UIImageView = {
        let img = makeImgView(name: "KakaoIcon.png")
        return img
    }()
    
    internal lazy var autoLoginImg: UIImageView = {
        let img = makeImgView(systemName: "square",
                          pallete: [.jjungColor],
                          tint: .jjungColor)
        return img
    }()
    
    private lazy var autoLoginView: UIView = {
        let view = UIView()
        let label = makeLabel(text: "자동로그인", font: font_NPS(.regular, 20))
        
        let autoBtn: UIButton = {
            let button = UIButton()
            button.tag = 3
            return button
        }()
        
        [
            self.autoLoginImg,
            label,
            autoBtn
        ].forEach{ view.addSubview($0) }
        
        self.autoLoginImg.snp.updateConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        label.snp.updateConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(self.autoLoginImg.snp.trailing).offset(10)
            $0.height.equalTo(30)
            $0.centerY.equalTo(self.autoLoginImg)
        }
        
        autoBtn.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        
        autoBtn.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var loginBtnView: UIView = {
        let view = UIView()
        [
            self.appleLoginBtn,
            self.kakaoLoginBtn,
            self.appleLogoImg,
            self.kakaoLogoImg,
            self.autoLoginView
        ].forEach{ view.addSubview($0) }
        
        self.appleLoginBtn.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        self.kakaoLoginBtn.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        
        
        self.appleLoginBtn.snp.updateConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        self.kakaoLoginBtn.snp.updateConstraints {
            $0.top.equalTo(self.appleLoginBtn.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self.appleLoginBtn)
            
            $0.height.equalTo(60)
        }
        self.appleLogoImg.snp.updateConstraints {
            $0.width.height.equalTo(50)
            $0.centerY.equalTo(self.appleLoginBtn)
            $0.leading.equalTo(self.appleLoginBtn).offset(35)
        }
        self.kakaoLogoImg.snp.updateConstraints {
            $0.width.height.equalTo(50)
            $0.centerY.equalTo(self.kakaoLoginBtn)
            $0.leading.equalTo(self.appleLogoImg)
        }
        self.autoLoginView.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.kakaoLoginBtn.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        return view
    }()
    
    internal lazy var testLoginTxf: UITextField = {
        let textField = UITextField()
        textField.font = font_NPS(.regular, 12)
        textField.placeholder = "Input Login ID"
        textField.textAlignment = .left
        textField.backgroundColor = .systemBackground
        textField.tintColor = .label
        textField.minimumFontSize = 17
        textField.adjustsFontSizeToFitWidth = T
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var testLoginView: UIView = {
        let view = UIView()
        view.backgroundColor = .viewBackColor
        view.layer.cornerRadius = 15
        
        let label = makeLabel(text: "Login ID", font: font_NPS(.regular, 20))
        
        let loginbtn: UICustomButton = {
            let button = UICustomButton()
            let text: String = "Login"
            
            let attribute = NSMutableAttributedString(string: text)
            attribute.addAttribute(.font,
                                   value: font_NPS(.regular, 20),
                                   range: (text as NSString).range(of: text))
            attribute.addAttribute(.foregroundColor,
                                   value: UIColor.black,
                                   range: (text as NSString).range(of: text))
            button.setAttributedTitle(attribute, for: .normal)
            
            button.backgroundColor = .backColor
            button.layer.cornerRadius = 15
            
            button.animateBig = T
            button.tag = 2
            
            return button
        }()
        [
            label,
            self.testLoginTxf,
            loginbtn
        ].forEach { view.addSubview($0) }
        
        label.snp.updateConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        self.testLoginTxf.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.height.equalTo(34)
        }
        loginbtn.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalTo(self.testLoginTxf)
            $0.top.equalTo(self.testLoginTxf.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        return view
    }()
    
    
    
    
    
// MARK: - END CREATE UI
    deinit {
        printFunc()
        self.coordinator?.popVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printFunc()
        self.setLayout()
    }
    
    private func setLayout() {
        @UserDefault(key: "testVer", defaultValue: "N") var testVer
        [
            self.titleView,
            self.loginBtnView
        ].forEach{ self.view.addSubview($0) }
        
        
        self.view.backgroundColor = .systemBackground
        
        self.titleView.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(150)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        self.loginBtnView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        if testVer == "Y" {
            self.view.addSubview(self.testLoginView)
            self.testLoginView.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview().inset(10)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            }
        }
    }
    
    
    
    @objc func tappedBtn(_ sender: UIButton) {
        if sender.tag == 0 {
            // 애플 로그인 버튼 눌렀을 때
            printLog("[Apple 계정으로 시작하기] 버튼 Tapped: sender.tag = \(sender.tag)")
            self.tryAppleLogin()
            
        }
        else if sender.tag == 1 {
            // 카카오 로그인 버튼 눌렀을 때
            printLog("[Kakao 계정으로 시작하기] 버튼 Tapped: sender.tag = \(sender.tag)")
            self.tryKakaoLogin()
        }
        else if sender.tag == 2 {
            // autoLogin 버튼 눌렀을 때
            printLog("[Test 로그인] 버튼 Tapped: sender.tag = \(sender.tag)")
            self.tryTestLogin()
        }
        else if sender.tag == 3 {
            // autoLogin 버튼 눌렀을 때
            printLog("[자동로그인] 버튼 Tapped: sender.tag = \(sender.tag)")
            self.checkedAutoLogin()
        }
    }
}
 /*
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


*/
