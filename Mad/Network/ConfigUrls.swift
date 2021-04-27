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
    // project
    static var getProject = BASE_URL  + "project/all"
    static var addToFavourite = BASE_URL  + "project/edit_favorite"
    static var shareProject = BASE_URL  + "project/share"
    static var getProjectDetails = BASE_URL  + "project/get"
    // artist
    static var getAllArtist = BASE_URL  + "artist/all"
    static var editArtistFavourite = BASE_URL  + "artist/edit_favorite"
    static var getSuggested = BASE_URL  + "artist/suggested"
    // product
    static var getAllProduct = BASE_URL  + "product/all"
    static var getSuggestedProduct = BASE_URL  + "product/suggested"


    
}
