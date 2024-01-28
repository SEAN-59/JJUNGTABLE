//
//  IntroVC_Layout.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 1/26/24.
//

extension IntroViewController {
    private func gotoMainVC() {
        if LoginManager().checkAutoLogin() {
            @UserDefault(key: "loginType", defaultValue: "") var loginType
            @UserDefault(key: "loginId", defaultValue: "") var loginId
            
            let type = {
                if loginType == "01" { return LoginType.apple }
                else if loginType == "02" { return LoginType.kakao }
                else if loginType == "03" { return LoginType.test }
                else { return LoginType.error }
            }()
            
            LoginManager().emailStartFunc(loginId, type) { emailResult in
                switch emailResult {
                case .success(_):

                    // SEAN: 20231029 - 자동로그인 성공! 바로 넘어갑시다 메인으로~
                    // SEAN: 20240125 - Coordinator Pattern 적용중
//                    self.popAndPushVC(nextVC: MainViewController(nibName: "MainViewController", bundle: nil))
                    
                    
                    break
                case .failure(_):
                        // SEAN: 20231029 - 자동로그인 실패한 거임 즉 알럿 띄우고 로그인 창으로~
                        makeAlert(self, title: "안내", message: "로그인 과정에서 문제가 발생하였습니다.\n 다시 시도해주시길 바랍니다.",
                                  actionTitle: ["확인"], handler: [{_ in
//                            self.popAndPushVC(nextVC: LoginViewController(nibName: "LoginViewController", bundle: nil))
//                            self.coordinator?.puchLoginVC()
//                            self.coordinator?.end()
                        }])
                }
            }
        }
        else {
            
            // SEAN: 20231029 - 자동로그인이 활성화 되어있지 않으니까 로그인 로직을 타야 함
            // SEAN: 20231029 - 값을 못불러온 경우나 해당 키가 없는 경우도 있을 테니까 그때도 로그인 로직
            self.coordinator?.choiceVC(.login, isPop: T)
//            self.popAndPushVC(nextVC: LoginViewController(nibName: "LoginViewController", bundle: nil))
//            self.coordinator?.puchLoginVC()
//            self.coordinator?.end()
        }
    }
    
    internal func showAlert(_ type: VersionAlert) {
        switch type {
        case .none:
            self.gotoMainVC()
        case .force:
            makeAlert(self, title: "업데이트 안내", message: "원할한 앱 사용을 위해서\n최신버전으로 업데이트 해주세요.",
                      actionTitle: ["지금 업데이트"], style: [.default],
                      handler: [
                        {_ in
                            printLog("강제 업데이트")
                            // 여기서 앱스토어로 보낼거임
//                                    let appStoreURL = URL(string: APPSTORE_DOWNLOAD)!
//                                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                        }
                      ]
            )
        case .choice:
            makeAlert(self, title: "업데이트 안내", message: "최신버전이 나왔어요.\n지급 업데이트 하시겠어요?",
                      actionTitle: ["지금 업데이트", "나중에"], style: [.default],
                      handler: [
                        {_ in
                            printLog("선택 업데이트")
                            // 여기서 앱스토어로 보낼거임
//                                        let appStoreURL = URL(string: APPSTORE_DOWNLOAD)!
//                                        UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                        },
                        {_ in
                            printLog("선택_나중에")
                            self.gotoMainVC()
                        }
                      ]
            )
        case .error:
            makeAlert(self, title: "안내", message: "서비스 이용에 문제가 발생했습니다.\n다시 시도해주세요..",
                      actionTitle: ["종료"], style: [.destructive], handler: [ {_ in exit(1)} ])
        }
    }
    
    

}

