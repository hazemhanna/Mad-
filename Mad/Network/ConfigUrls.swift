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
    static var getCountry = BASE_URL  + "active_countries"
    static var getCategeory = BASE_URL  + "categories"
    // project
    static var getProject = BASE_URL  + "project/all"
    static var addToFavourite = BASE_URL  + "project/edit_favorite"
    static var shareProject = BASE_URL  + "project/share"
    static var getProjectDetails = BASE_URL  + "project/get"
    static var createProject = BASE_URL  + "project/create"

    // artist
    static var addArtistToFavourite = BASE_URL  + "artist/edit_favorite"
    static var getAllArtist = BASE_URL  + "artist/all"
    static var getArtistProfile = BASE_URL  + "artist/get"
    static var editArtistFavourite = BASE_URL  + "artist/edit_favorite"
    static var getSuggested = BASE_URL  + "artist/suggested"
    // product
    static var getAllProduct = BASE_URL  + "product/all"
    static var getSuggestedProduct = BASE_URL  + "product/suggested"
    static var getTopProduct = BASE_URL  + "product/suggested"
    static var getProductDetails = BASE_URL  + "product/get"
    static var addProductToFavourite = BASE_URL  + "product/edit_favorite"
    static var shareProduct = BASE_URL  + "product/share"
    static var createProduct = BASE_URL  + "product/create"
    static var catProduct = BASE_URL  + "categories/product"
    static var artistProduct = BASE_URL  + "product/get_for_artist"
    // video
    static var getAllvideos = BASE_URL  + "video/all"
    static var getVideoDetails = BASE_URL  + "video/get"
    static var addVideoToFavourite = BASE_URL  + "video/edit_favorite"
    static var shareVideo = BASE_URL  + "video/share"
    // competition
    static var getAllCompetition = BASE_URL  + "competition/all"
    // search
    static var search = BASE_URL  + "search"

    
   
    
}
