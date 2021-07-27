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
    static var getCompetitionDetails = BASE_URL  + "competition/get"
    static var addCompetition = BASE_URL  + "competition/compete"
    static var voteCompetition = BASE_URL  + "competition/vote"
    static var aboutCompetition = BASE_URL  + "competition/know_about"
    // search
    static var search = BASE_URL  + "search"
    static var popularSearch = BASE_URL  + "search/get_recent"
    static var addNewVisit = BASE_URL  + "search/add_new_visit"
    static var removeVisit = BASE_URL  + "search/remove_visit"
    // cart
    static var addToCart = BASE_URL  + "cart/add_product"
    static var getCart = BASE_URL  + "cart/get_content_for_user"
    static var getCartDetails = BASE_URL  + "cart/get_details"
    static var updateCartDetails = BASE_URL  + "cart/update_details"
    static var updateCartProduct = BASE_URL  + "cart/update_product"
    // order
    static var getOrders = BASE_URL  + "order"
    static var getOrdersDetails = BASE_URL  + "order/get"
    // blogs
    static var allBlogs  = BASE_URL  + "blog/all"
    static var blogDetails  = BASE_URL  + "blog/get"
    // chat
    
    static var creatConverstion  = BASE_URL  + "conversation/create"
    static var getAllConverstion  = BASE_URL  + "conversation"

    static var getAllMessages  = BASE_URL  + "conversation/get_messages"

    static var sendMessages  = BASE_URL  + "conversation/send_message"

}
