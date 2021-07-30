//
//  Helper.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import Foundation
import UIKit

class Helper {
    
    struct UIApplicationURL{
        static func openUrl(url:String,isEmail:Bool = false) {
            if isEmail {
                let email = url
                if let url = URL(string: "mailto:\(email)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }else {
                if let url = URL(string: url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:])
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
        
    class func saveAlogin(token: String,email: String,fName:String,lName:String,type:Bool,id:Int,isActive:Bool) {
        let def = UserDefaults.standard
        def.set(token, forKey: "token")
        def.set(email, forKey: "email")
        def.set(fName, forKey: "fName")
        def.set(lName, forKey: "lName")
        def.set(type, forKey: "type")
        def.set(id, forKey: "id")
        def.set(isActive, forKey: "isActive")
        def.synchronize()
    }
    
    class func LogOut() {
        let def = UserDefaults.standard
        def.removeObject(forKey: "token")
        def.removeObject(forKey: "email")
        def.synchronize()
    }
    
    class func getAPIToken() -> String? {
           let def = UserDefaults.standard
           return def.object(forKey: "token") as? String
       }
    
    class func getId() -> Int? {
           let def = UserDefaults.standard
           return def.object(forKey: "id") as? Int
       }
    
    class func getIsActive() -> Bool? {
           let def = UserDefaults.standard
           return def.object(forKey: "isActive") as? Bool
       }
    
    
    class func getFName() -> String? {
           let def = UserDefaults.standard
           return def.object(forKey: "fName") as? String
       }
    class func getLName() -> String? {
           let def = UserDefaults.standard
           return def.object(forKey: "lName") as? String
       }

    class func getType() -> Bool? {
           let def = UserDefaults.standard
           return def.object(forKey: "type") as? Bool
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
    
    class func saveCountry(id: String) {
        let def = UserDefaults.standard
        def.set(id, forKey: "Id")
        def.synchronize()
    }
    class func getUserCountry() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "Id") as? String
    }
    
    class func saveArtistId(id: Int) {
        let def = UserDefaults.standard
        def.set(id, forKey: "artistId")
        def.synchronize()
    }
    
    class func getArtistId() -> Int? {
        let def = UserDefaults.standard
        return def.object(forKey: "artistId") as? Int
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
    
    
    class func saveDate1(code: String) {
        let def = UserDefaults.standard
        def.set(code, forKey: "date1")
        def.synchronize()
    }
    class func getDate1() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "date1") as? String
    }
    
    class func saveDate2(code: String) {
        let def = UserDefaults.standard
        def.set(code, forKey: "date2")
        def.synchronize()
    }
    class func getDate2() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "date2") as? String
    }
}
