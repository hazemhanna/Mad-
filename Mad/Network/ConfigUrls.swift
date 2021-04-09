//
//  ConfigUrls.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import Foundation
import Foundation

var BASE_URL = "http://mad.cnepho.com/api/"

struct ConfigURLS {
    
    //MARK:- POST Register
    static var postRegister = BASE_URL  + "auth/register"
    static var checkOtp = BASE_URL  + "auth/check_otp"
    static var completeRegister = BASE_URL  + "auth/complete_profile"
    static var login = BASE_URL  + "auth/login"
    static var getCountry = BASE_URL  + "countries"
    static var getCategeory = BASE_URL  + "categories"

    
}
