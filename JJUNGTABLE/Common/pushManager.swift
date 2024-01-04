//
//  pushManager.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/14/23.
//

import UIKit

//import UserNotifications

import FirebaseCore
import FirebaseMessaging

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func pushSetup(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        
        application.registerForRemoteNotifications()
    }
    
    func fcmSetup() {
        Messaging.messaging().delegate = self
//        Messaging.messaging().isAutoInitEnabled = true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let strDeviceToken = deviceToken.reduce("",{$0 + String(format: "%02.2hx", $1)})
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        printLog("Noti Token: \(token)")
        @UserDefault(key: "pushToken", defaultValue: "")var pushToken
        pushToken = token
        #if FCM
//        Messaging.messaging().apnsToken = deviceToken
        #endif
    }
    
    //APNs 서버가 어떠한 이유로 연결이 되지 않는 경우(네트워크 문제)나 앱이 자격을 갖지 못하는 경우
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printLog("[ERROR] NotiError: \(error)")
    }
    
    //MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            printLog("MessageId: \(messageID)")
        }
        #if FCM
//        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        #endif
        
        
        if #available(iOS 14.0, *) {
            return [[.list,.banner,.sound]]
        } else {
            return[[.alert,.sound]]
        }
        
        
    }
    
    // 나타난 push를 누를 경우 동작하는 함수
///    [FCM 온거 누르니까 나타난 내용]
///    Noti JSON: [AnyHashable("google.c.a.e"): 1, AnyHashable("google.c.a.c_id"): 7338336009336023178, AnyHashable("google.c.a.udt"): 0, AnyHashable("gcm.n.e"): 1, AnyHashable("google.c.a.ts"): 1699941363, AnyHashable("google.c.fid"): eKmjydXES0TNhh12WTzxLd, AnyHashable("gcm.message_id"): 1699941581422658, AnyHashable("google.c.sender.id"): 480609810019, AnyHashable("aps"): {
///     alert =     {
///     body = TEST;
///     title = TEST;
///     };
///    badge = 1;
///    "mutable-content" = 1;
///    }, AnyHashable("google.c.a.c_l"): TEST]
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        printLog("Noti JSON: \(userInfo)")
    }
    
    
    //MARK: - MessagingDelegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String:String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}


struct PushManager {
    // 로컬 push 보낼 때 사용
    func pushNotification(title: String, body: String, time: Double, identifier: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
