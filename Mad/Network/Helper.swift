//
//  Helper.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import Foundation
import UIKit

class Helper {
    class func saveAlogin(token: String,email: String) {
        let def = UserDefaults.standard
        def.set(token, forKey: "token")
        def.set(email, forKey: "email")
        def.synchronize()
    }
    
    class func getAPIToken() -> String? {
           let def = UserDefaults.standard
           return def.object(forKey: "token") as? String
       }
    
    class func LogOut() {
        let def = UserDefaults.standard
        def.removeObject(forKey: "token")
        def.removeObject(forKey: "email")
        def.synchronize()
    }
    
    

    class func saveEmial(email: String) {
        let def = UserDefaults.standard
        def.set(email, forKey: "email")
        def.synchronize()
    }
    
    class func getUserEmail() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "email") as? String
    }
    
    class func savePAssword(pass: String) {
        let def = UserDefaults.standard
        def.set(pass, forKey: "password")
        def.synchronize()
    }
    
    class func getUserPass() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "password") as? String
    }

    class func saveFirstName(firstName: String) {
        let def = UserDefaults.standard
        def.set(firstName, forKey: "firstName")
        def.synchronize()
    }
    
    class func getUserFirstName() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "firstName") as? String
    }

    
    class func saveLastName(LastName: String) {
        let def = UserDefaults.standard
        def.set(LastName, forKey: "LastName")
        def.synchronize()
    }
    
    class func getUserLastName() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "LastName") as? String
    }

    
    class func saveAge(Age: String) {
        let def = UserDefaults.standard
        def.set(Age, forKey: "Age")
        def.synchronize()
    }
    
    class func getUserAge() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "Age") as? String
    }
    
    class func saveCountry(id: Int) {
        let def = UserDefaults.standard
        def.set(id, forKey: "Id")
        def.synchronize()
    }
    class func getUserCountry() -> Int? {
        let def = UserDefaults.standard
        return def.object(forKey: "Id") as? Int
    }
    
    class func saveCode(code: String) {
        let def = UserDefaults.standard
        def.set(code, forKey: "code")
        def.synchronize()
    }
    class func getUserCode() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "code") as? String
    }
    
    class func saveUSerType(type: Int) {
        let def = UserDefaults.standard
        def.set(type, forKey: "type")
        def.synchronize()
    }
    
    class func getUserType() -> Int? {
        let def = UserDefaults.standard
        return def.object(forKey: "type") as? Int
    }
    
    
    
}
