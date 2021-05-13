//
//  AppDelegate.swift
//  Mad
//
//  Created by MAC on 29/03/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var token = Helper.getAPIToken()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        if token != nil {
//            let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardTabBarController")
//            window?.rootViewController = sb
//        }else {
        let sb = SplashVC.instantiateFromNib()
         window?.rootViewController = sb
        //}
        return true
    }
    
}

