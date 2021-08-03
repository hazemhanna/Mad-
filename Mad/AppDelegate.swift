//
//  AppDelegate.swift
//  Mad
//
//  Created by MAC on 29/03/2021.
//

import UIKit
import Stripe


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var token = Helper.getAPIToken() ?? ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if token !=  "" {
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardTabBarController")
        window?.rootViewController = sb
        }else {
        let sb = SplashVC.instantiateFromNib()
         window?.rootViewController = sb
        }
        
        StripeAPI.defaultPublishableKey = "pk_test_51JK7koDEjVvEhMZXSuT96D66jyAu1RI1myrcSa9M2ej5MJZSvSDeTEFSXkpHajtxgXPtenYxL45b63eeNv22yHD600vVMWrN64"
        
      // Secret key "sk_test_51JK7koDEjVvEhMZX2FF1DlIllL4RxVNU1RaslJhxzNRmP4sDJqgsXZXmzLrZuez1laNAznSpIva4CpGSInATwpqG00D6jjaqzm"

        return true
    }
}
