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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

       // let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        let sb = Tutorial1.instantiateFromNib()
         window?.rootViewController = sb
        
        return true
    }
    
}

