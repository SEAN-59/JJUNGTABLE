//
//  LoginManager.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/29/23.
//

import Foundation

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth

// 탈퇴하면 user, tableId, friend

// 로그인 타입: 애플 = 01 , 카카오 = 02
struct LoginManager {
    
    func startLogin(_ type: LoginType, completion: @escaping (Bool) -> ()) {
        
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        @UserDefault(key: "loginType", defaultValue: "") var loginType
        
        switch type {
        case .apple:
            break
//            AppleLogin().startLogin()
//            loginId = success.id
//            loginType = "01"
        case .kakao:
            self.kakaoTryLogin { loginResult in
                switch loginResult {
                case .success(let success):
                    self.emailStartFunc(success.id, success.type) { emailResult in
                        switch emailResult {
                        case .success(_):
                            loginId = success.id
                            loginType = "02"
                            completion(true)
                        case .failure(let error):
                            printLog("[ERROR] LOGIN ERROR: \(error)")
                            _loginId.removeData()
                            _loginType.removeData()
                            completion(false)
                        }
                    }
                case .failure(let error):
                    printLog("[ERROR] LOGIN ERROR: \(error)")
                    completion(false)
                }
            }
            
        case .test :
            // 어차피 이거 안탈거임
            break
            
        case .error:
            printLog("Error LoginType")
            completion(false)
        }
    }
    
    
    func checkAutoLogin() -> Bool{
        @UserDefault(key: "AutoLogin", defaultValue: "") var autoLogin
        if autoLogin == "Y" { return true }
        else { return false }
    }
    
    func deleteLoginID(completion: @escaping (Result<Void,LOGIN_ERROR>) -> Void) {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
              printLog("[ERROR] ID DELETE ERROR: \(error)")
              completion(.failure(.email_DeleteERROR))
          } else {
              completion(.success(()))
          }
        }
    }
    
    func logout() {
        let nextVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        printLog(viewControllers)
        viewControllers.last?.popAndPushVC(nextVC: nextVC)
    }
    
    // 이거 뭐하는 용도의 메서드임?
    func checkUserInfo(_ type: LoginType) {
        switch type {
        case .apple:
            break
        case .kakao:
            break
        case .test:
            break
        case .error:
            break
        }
    }
}

// SEAN: 20231101 - Source 파일을 따로 관리 했는데 매니저 파일 내부로 합치는 작업
// MARK: - KAKAO LOGIN
private extension LoginManager {
    func kakaoTryLogin(completion: @escaping (Result<LoginData, LOGIN_ERROR>) -> ()) {
        // 카톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                if let error = error {
                    printLog("[ERROR] login KakaoTalk: \(error)")
                    completion(.failure(.kakao_LoginERROR))
                }
                
                else {
                    printLog("Pass KakaoTalk")
                    self.kakaoAccessUserInfo { kakaoAccessResult in
                        switch kakaoAccessResult {
                        case .success(let id):
                            printLog("Access Kakao userInfo: \(id)")
                            completion(.success(.init(id: id, type: .kakao)))
                        case .failure(let error):
                            printLog("[ERROR] \(error)")
                            completion(.failure(error))
                        }
                    }
                }
                _ = oAuthToken
            }
        }
        else {
            UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
                if let error = error {
                    printLog("[ERROR] login Kakao Account: \(error)")
                }
                else {
                    printLog("Pass Kakao Account")
                }
                _ = oAuthToken
            }
        }
    }
    
    // SEAN: 20231028 - 사용자 정보 확인하기
    func kakaoAccessUserInfo(completion: @escaping (Result<String, LOGIN_ERROR>) -> ()) {
        UserApi.shared.me { user, error in
            if let error = error {
                printLog("[ERROR] Kakao me: \(error)")
                completion(.failure(.kakao_AccessUserERROR))
            }
            else if let user = user, let id = user.id {
                printLog("Access Kakao UserInfo")
                completion(.success("\(id)"))
                
            }
            else {
                completion(.failure(.kakao_AccessUserERROR))
            }
            
            
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.logout { error in
            if let error = error {
                printLog("Error kakao logout: \(error)")
            }
            else {
                printLog("Success Kakao logout")
            }
        }
    }
    
    // SEAN: 20231028 - 연결 끊기
    func kakaoUnlink() {
        UserApi.shared.unlink { error in
            if let error = error {
                printLog("Error kakao unlink: \(error)")
            }
            else {
                printLog("Success Kakao unlink")
            }
        }
    }
}

// MARK: - E-MAIL LOGIN
extension LoginManager {
    func emailStartFunc(_ snsId: String, _ loginType: LoginType, completion:  @escaping (Result<Void,LOGIN_ERROR>) -> ()) {
        var id = ""
        var pw = ""
        switch loginType {
        case .apple:
            id = "\(snsId)@apple.com"
            pw = "apple\(snsId)"
        case .kakao:
            id = "\(snsId)@kakao.com"
            pw = "kakao\(snsId)"
        case .test:
            id = "\(snsId)@login.id"
            pw = "login\(snsId)id"
            break
        case .error:
            break
        }
        
        self.emailTryLogin(id, pw) { emailLoginResult in
            switch emailLoginResult {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func emailTryLogin(_ id: String, _ pw: String, completion: @escaping (Result<Void,LOGIN_ERROR>) -> ()) {
        Auth.auth().signIn(withEmail: id, password: pw) { authResult, error in
            if error != nil {
                printLog("[ERROR] Firebase SignIn User")
                self.emailCreateAccount(id, pw) { emailCreateResult in
                    switch emailCreateResult {
                    case .success(let result):
                        completion(.success(result))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            else {
                printLog("Success Firebase SignIn User")
                completion(.success(()))
            }
        }
    }
    
    private func emailCreateAccount(_ id: String, _ pw: String, completion: @escaping (Result<Void,LOGIN_ERROR>) -> ()) {
        Auth.auth().createUser(withEmail: id, password: pw) { authResult, error in
            if error != nil {
                printLog("[ERROR] Firebase Create Email")
                completion(.failure(.email_CreateERROR))
            }
            else {
                completion(.success(()))
            }
        }
    }
    
//    private func emailDeleteAccount(completion: @escaping (Result<Void,LOGIN_ERROR>) -> Void) {
//        let user = Auth.auth().currentUser
//
//        user?.delete { error in
//          if let error = error {
//              printLog("[ERROR] ID DELETE ERROR: \(error)")
//              completion(.failure(.email_DeleteERROR))
//          } else {
//              completion(.success(()))
//          }
//        }
//        
//    }
}


//extension LoginManager: DatabaseDelegate {
//    
//}
