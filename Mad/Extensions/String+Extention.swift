//
//  String+Extention.swift
//  Mad
//
//  Created by MAC on 21/04/2021.
//

import Foundation
import SwiftMessages


//MARK:- Display normal Alert
public func displayMessage(title: String, message: String, status: Theme, forController controller: UIViewController) {
    let success = MessageView.viewFromNib(layout: .cardView)
    success.configureTheme(status, iconStyle: .default )
    success.configureDropShadow()
    success.configureContent(title: title, body: message)
    success.button?.isHidden = true
    var successConfig = SwiftMessages.defaultConfig
    successConfig.duration = .seconds(seconds: 2)
    successConfig.presentationStyle = .top
    successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
    SwiftMessages.show(config: successConfig, view: success)
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}


extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: self)
    }
}


extension String {
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    
    public func localizedStringFor(key:String)->String {
        return NSLocalizedString(key, comment: "")
    }
    
    var localized: String {
        return localizedStringFor(key: self)
    }
    
    
    public var arToEnDigits : String {
        let arabicNumbers = ["٠": "0","١": "1","٢": "2","٣": "3","٤": "4","٥": "5","٦": "6","٧": "7","٨": "8","٩": "9"]
        var txt = self
        arabicNumbers.map { txt = txt.replacingOccurrences(of: $0, with: $1)}
        return txt
    }
    
    //Validate Name
    func isValidInput() -> Bool {
        let RegEx = "^\\w{7,50}$"
        let Test = NSPredicate(format:"SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z0-9].*[a-zA-Z0-9]$)([^ ]?))$", RegEx)
        return Test.evaluate(with: self)
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func isPasswordValid() -> Bool {
       // let passwordRegex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[@#$%^&*!]).{8,}"
        let passwordRegex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[~@#$%^&*:;<>.,/}{+!?|()_=`]).{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return  predicate.evaluate(with: self)
    }
    func isPhone() -> Bool {
        if self.isAllDigits() == true {
            let phoneRegex = "^(009665|9665|\\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return  predicate.evaluate(with: self)
        }else {
            return false
        }
    }
    func validateEnglishCharsInput() -> Bool {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: self)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return alphabet
    }
    func isAllDigits() -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    var parseHtml: String {
        
        let encodedData = self.data(using: String.Encoding.utf8)!
        do {
            let x = try NSAttributedString(data: encodedData,     options: [.documentType: NSAttributedString.DocumentType.html,
                                                                            .characterEncoding: String.Encoding.utf8.rawValue],
                                           documentAttributes: nil)
            let message = x.string
            return message
        } catch let error as NSError {
            print(error.localizedDescription)
            return ""
        }
    }
    func checkCount() -> Bool{
        if self.count >= 191{
            return false
        }else{
            return true
        }
    }
    func verifyUrl () -> Bool {
        if self.range(of:".") != nil {
            return true
        }
        else{
            return false
        }
    }
    func convertStringToJSON() -> [String: Any]? {
        
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any]
            {
               return jsonArray
            } else {
                return nil
            }
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
}

extension Date {

func getElapsedInterval() -> String {

    let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())

    if let year = interval.year, year > 0 {
        return year == 1 ? "\(year)" + " " + "year ago" :
            "\(year)" + " " + "years ago"
    } else if let month = interval.month, month > 0 {
        return month == 1 ? "\(month)" + " " + "month ago" :
            "\(month)" + " " + "months ago"
    } else if let day = interval.day, day > 0 {
        return day == 1 ? "\(day)" + " " + "day ago" :
            "\(day)" + " " + "days ago"
    } else {
        return "a moment ago"

    }

}
}
