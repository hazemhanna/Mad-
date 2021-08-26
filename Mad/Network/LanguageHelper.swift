//
//  LanguageHelper.swift
//  Mad
//
//  Created by MAC on 24/08/2021.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

enum Language :String{

    case English
    case French
  //case français
    
    func isEnglish()->Bool{
        return self.rawValue == Language.English.rawValue
    }

    init?(lang: String) {
        switch lang {
        case let x where x.hasPrefix("fr") : self = .French
        case let x where x.hasPrefix("en") : self = .English
            
        default: self = .French
        }
    }
    
    
    static var array = [French,English]
    func title ()->String{
        switch self {

        case .English:
            return "English"
        case . French:
            return "French"
        }
        
    }
    
    func isRtl ()->Bool{
        switch self {

        case .English:
            return false
        case .French :
            return false
        }
        
    }
    
    
        func apiKey()->String {
            switch self {
            case .English:
                return "en-US"
            case .French :
                return "fr"
            }
        }

        func key()->String {
            switch self {
            case .English:
                return "en-US"
            case .French :
                return "fr"
            }
        }
    
}

class LanguageHelper {
        
        private var currentLang:Language!
        private static var currentLanguage:LanguageHelper!
        static func sharedDelegate()->LanguageHelper{
            if currentLanguage == nil {
                currentLanguage = LanguageHelper()
            }

            return currentLanguage
        }

    init() {
            
        }
        open func setLangauge(lang: Language){
            UserDefaults.standard.setValue([lang.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            currentLang = lang
        }
    
    var launchedLang : Language!

    open func getLanguage() -> Language
    {
        if currentLang == nil {
            let lang = Locale.preferredLanguages[0]
            currentLang = Language(lang: lang)!
            launchedLang = currentLang
        }
        return currentLang
    }
    
}
