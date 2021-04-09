//
//  Helper.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import Foundation
import UIKit

class Helper {
    
    class func saveAPIToken(token: String) {
        let def = UserDefaults.standard
        def.set(token, forKey: "token")
        def.synchronize()
    }
    
    
    class func getAPIToken() -> String? {
           let def = UserDefaults.standard
           return def.object(forKey: "token") as? String
       }
    

    class func saveUserEmail(Email: String) {
        let def = UserDefaults.standard
        def.set(Email, forKey: "email")
    }
    
    class func getUserEmail() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "email") as? String
    }
    
    
    class func LogOut() {
        let def = UserDefaults.standard
        def.removeObject(forKey: "token")
        def.removeObject(forKey: "email")
        def.synchronize()
    }
    
    
}
