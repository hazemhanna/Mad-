//
//  ArtistViewModel.swift
//  Mad
//
//  Created by MAC on 21/04/2021.
//

import Foundation
import RxSwift
import SVProgressHUD
import UIKit

struct ArtistViewModel {
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getAllArtist(pageNum :Int) -> Observable<ArtistsMainModel> {
        let params: [String: Any] = [
            "page_number": pageNum
        ]
        let observer = GetServices.shared.getAllArtist(param : params)
         return observer
     }
    
    func getTopArtist(pageNum :Int,catId :Int) -> Observable<ArtistsMainModel> {
        let params: [String: Any] = [
            "page_number": pageNum
        ]
        let observer = GetServices.shared.getTopArtist(param : params,catId : catId)
         return observer
     }
    
    func addToFavourite(artistId : Int,Type : Bool) -> Observable<ArtistFavouriteModel> {
        let params: [String: Any] = [
            "artist_id": artistId,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addArtistToFavourite(param : params)
         return observer
     }
    
    func addToFavouriteProduct(productId : Int,Type : Bool) -> Observable<ProductFavouriteModel> {
        let params: [String: Any] = [
            "product_id": productId,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addProductToFavourite(param : params)
         return observer
     }

    
    func addToFavouriteProject(productID : Int,Type : Bool) -> Observable<FavouriteModel> {
        let params: [String: Any] = [
            "project_id": productID,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addToFavourite(param : params)
         return observer
     }
    
    func shareProject(productID : Int) -> Observable<ShareModel> {
        let params: [String: Any] = [
            "project_id": productID,
            ]
        let observer = AddServices.shared.shareProject(param : params)
         return observer
     }
    
    func getSuggested() -> Observable<SuggestedModel> {
         let observer = GetServices.shared.getSuggested()
         return observer
     }
    
    func getArtistProfile(artistId : Int) -> Observable<ArtistProfileModelJSON> {
        let params: [String: Any] = [
            "id": artistId,
            ]
        let observer = GetServices.shared.getArtistProfile(param : params)
         return observer
     }
    
    func getMyProfile() -> Observable<ProfileModelJSON> {
         let observer = GetServices.shared.getMyProfile()
         return observer
     }
    
    func updateBanner(image : UIImage) -> Observable<AddProductModelJson> {
        let observer = AddServices.shared.updateBanner(image : image)
         return observer
     }
    
    func updateProfile(image : UIImage) -> Observable<AddProductModelJson> {
        let observer = AddServices.shared.updateProfile(image: image)
         return observer
     }
    
    
    func updateUSerProfile(email : String,phone : String,firstName : String,lastName : String) -> Observable<ProfileModelJSON> {
        let  params: [String: Any] = [
            "email": Helper.getUserEmail() ?? "" ,
            "first_name": firstName,
            "last_name": lastName,
            "phone": phone
          ]
        let observer = Authentication.shared.updateProfile(params: params)
        return observer
        
    }
    
    func updateProfile(firstName: String,lastName: String,age: String,about: String,instgram: String,faceBook: String,twitter: String, phone : String,headLine : String,music : Bool,art : Bool,design : Bool) -> Observable<ProfileModelJSON> {
        let  params: [String: Any] = [
            "email": Helper.getUserEmail() ?? "" ,
            "first_name": firstName,
            "last_name": lastName,
            "headline": headLine,
            "about":about ,
            "phone": phone,
            "age": age,
            "country": "lebnan",
            "facebook": faceBook,
            "instagram": instgram,
            "twitter":twitter,
             "public_name":firstName + lastName,
            "category_music":music,
            "category_art":art,
            "category_design":design
          ]
        let observer = Authentication.shared.updateProfile(params: params)
        return observer
    }
    
    func upgradeMyProfile(firstName: String,lastName: String,age: String,about: String,instgram: String,faceBook: String,twitter: String, phone : String,headLine : String,music : Bool,art : Bool,design : Bool) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
             "email": Helper.getUserEmail() ?? "" ,
             "first_name": firstName,
             "last_name": lastName,
             "headline": headLine,
             "about":about ,
             "phone": phone,
             "age": age,
             "country": "lebnan",
             "facebook": faceBook,
             "instagram": instgram,
             "twitter":twitter,
              "public_name":firstName + lastName,
             "category_music":music,
             "category_art":art,
             "category_design":design
           ]
        let observer = Authentication.shared.upgradeMyProfile(params: params)
        return observer
    }
    
    
    func getAllCountries() -> Observable<CountryModel> {
         let observer = GetServices.shared.getAllCountry()
         return observer
     }
    
    func addToFavourite(videoId : Int,Type : Bool) -> Observable<VideoFavouriteMdel> {
        let params: [String: Any] = [
            "video_id": videoId,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addVideoToFavourite(param : params)
         return observer
     }
    
    
    func shareVideo(videoId : Int) -> Observable<ShareModel> {
        let params: [String: Any] = [
            "video_id": videoId,
            ]
        let observer = AddServices.shared.shareVideo(param : params)
         return observer
     }
    
    
    func uploadVideo(product : [Int]
                     ,project : [Int]
                     ,associated_artists : [Int]
                     ,description : String
                     ,name : String
                     ,image_url : UIImage
                     ,videoUrl: Data) -> Observable<AddProductModelJson> {
        
        let params: [String: Any] = [
            "name": name,
            "agree_with_terms": 1,
            "description" :description,
            "associated_artists" :associated_artists,
            "product" :product,
            "project" :project]
        
        let observer = AddServices.shared.uploadVideo(image_url: image_url, videoUrl:videoUrl,parameters: params)
        return observer
    }


    func forgetPassword() -> Observable<AddProductModelJson> {
        let bindedEmail = Helper.getUserEmail() ?? ""
         let params: [String: Any] = [
            "email": bindedEmail,
           ]
        let observer = Authentication.shared.forgetPassword(params: params)
        return observer
    }
    
    func hideProject(id : Int,hide : Int) -> Observable<ProjectDetailsModel> {
        let  params: [String: Any] = ["project_id": "\(id)","hide": hide]
        let observer = Authentication.shared.hideProject(params: params)
        return observer
    }
    
}
