//
//  AppDelegate.swift
//  Mad
//
//  Created by MAC on 29/03/2021.
//

import UIKit
import Stripe
import Firebase
import UserNotifications
import FirebaseMessaging
import RxSwift
import RxCocoa

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var disposeBag = DisposeBag()
    var authVM = AuthenticationViewModel()
    
    var token = Helper.getAPIToken() ?? ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if token !=  "" {
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardTabBarController")
        window?.rootViewController = sb
        }else {
        let sb = SplashVC.instantiateFromNib()
         window?.rootViewController = sb
        }
        
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("didReceiveRemoteNotification FUll Message: \(userInfo)")
       
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                Helper.saveDeviceToken(token: result.token)
                if self.token != "" {
                    self.authVM.postFCM(token:  result.token).subscribe(onNext: { (dataModel) in
                       if dataModel.success ?? false {
                       
                       }
                   }, onError: { (error) in

                   }).disposed(by: self.disposeBag)
                }
            }
        })
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print("willPresent UNUserNotificationCenter FUll Message: \(userInfo)")
        //MARK:- Handling Location Notification
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")
        // Change this to your preferred presentation option
        completionHandler([.badge, .sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        //MARK:- Handling Location Notification
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")
        let type = userInfo["type"] as? String ?? ""
        let role = userInfo["role"] as? String ?? ""
        let idd = userInfo["id"] as? String ?? ""
        let chat_type = userInfo["chat_type"] as? String ?? ""
        print(type)
        print(role)
        print(idd)
        print(userInfo)
        print(chat_type)
        
        // Print full message.
        print("didReceive UNUserNotificationCenter FUll Message: \(userInfo)")

        completionHandler()
    }
}
// [END ios_10_message_handling]


extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    if let deviceToken = fcmToken {
        
        UserDefaults.standard.setValue(deviceToken, forKey: "deviceToken")
    }
    
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
}
