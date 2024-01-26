//
//  AppDelegate.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/26/23.
//

import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFunctions

import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 파이어베이스 설정 부분
        FirebaseApp.configure()
        
        // 카카오 SDK 초기화 코드
        KakaoSDK.initSDK(appKey: KEY.kakaoAppKey)
        
        #if FCM
        // fcm 세팅
        self.fcmSetup()
        #endif
        
        // notification 세팅
        self.pushSetup(application)
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
}

