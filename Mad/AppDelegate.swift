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
import IQKeyboardManagerSwift
import FirebaseDynamicLinks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var disposeBag = DisposeBag()
    var authVM = AuthenticationViewModel()
    
    var token = Helper.getAPIToken() ?? ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        StripeAPI.defaultPublishableKey = "pk_test_51GyE2kEh66Mr30iHouPsi3IfxNmFNI1IsBFvASIERi9RsbFXeOfQyiC3r5cwqwE7OYjqTcJIa1bFWsj84h9nayt500EB57inlh"
        if token !=  "" {
         let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardTabBarController")
         window?.rootViewController = sb
        }else {
         let sb = SplashVC.instantiateFromNib()
         window?.rootViewController = sb
        }
        
        
        FirebaseApp.configure()
        registerForRemoteNotification()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        application.applicationIconBadgeNumber = 0
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized
        return true
    }
    
    


    func handelDynamiclink( _ dynamiclink : DynamicLink)  {
        let imageDataDict:[String: DynamicLink] = ["dynamiclink": dynamiclink]
        NotificationCenter.default.post(name: Notification.Name("component"), object: nil, userInfo: imageDataDict)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
          if let dynamiclink = dynamiclink{
             self.handelDynamiclink(dynamiclink)
          }
      }
      return handled
    }
    
    func application(_ app: UIApplication, open url: URL,options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return application(app, open: url,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
        return true
      }
      return false
    }
    
    func registerForRemoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error == nil {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("deviceTokenString \(deviceTokenString)")
        
    }
}

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      messaging.subscribe(toTopic: "General")
      if let fcmToken = fcmToken {
          print("Firebase registration token: \(fcmToken)")
          let token = Messaging.messaging().fcmToken
          print("FCM token: \(token ?? "")")
          updateFirestorePushTokenIfNeeded(fcmToken: fcmToken)
      }
  }
    
    func updateToken(token: String) {
            if self.token != "" {
                self.authVM.postFCM(token:  token).subscribe(onNext: { (dataModel) in
                if dataModel.success ?? false {
                    print(dataModel)
                  }
                 }, onError: { (error) in
                     print(error.localizedDescription)
                }).disposed(by: self.disposeBag)
             }
     }
    
    func updateFirestorePushTokenIfNeeded(fcmToken: String) {
        if let currentFcmToken = Helper.getDeviceToken(), currentFcmToken == fcmToken {
            updateToken(token: fcmToken)
            print("token: \(fcmToken)")
        } else {
            Helper.saveDeviceToken(token: fcmToken)
            updateToken(token: fcmToken)
            print("token: \(fcmToken)")
        }
    }
    
}
