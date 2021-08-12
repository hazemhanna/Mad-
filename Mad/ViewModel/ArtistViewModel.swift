//
//  ArtistViewModel.swift
//  Mad
//
//  Created by MAC on 21/04/2021.
//

import Foundation
import RxSwift
import SVProgressHUD

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
    
    func updateProfile(email : String,phone : String,firstName : String,lastName : String,age : String,country : String,about : String,headLine : String,instgram : String,faceBook : String,twitter : String,active :Bool) -> Observable<ProfileModelJSON> {
        var  params: [String: Any] = [
            "email": email,
            "first_name": firstName,
            "last_name": lastName,
            "phone": phone,
            "age": age,
            "country": country,
            "facebook": faceBook,
            "instagram": instgram,
            "twitter":twitter
           ]
        if active{
            params["headline"] = headLine
            params["about"] = about
        }
        let observer = Authentication.shared.updateProfile(params: params)
        return observer
    }
    
    func upgradeMyProfile(email : String,phone : String,firstName : String,lastName : String,age : String,country : String,about : String,headLine : String,instgram : String,faceBook : String,twitter : String) -> Observable<ProfileModelJSON> {
        let params: [String: Any] = [
            "email": email,
            "first_name": firstName,
            "last_name": lastName,
            "headline": headLine,
            "about":about ,
            "phone": phone,
            "age": age,
            "country": country,
            "facebook": faceBook,
            "instagram": instgram,
            "twitter":twitter
           ]
       
        
        let observer = Authentication.shared.upgradeMyProfile(params: params)
        return observer
    }
    
    
    func getAllCountries() -> Observable<CountryModel> {
         let observer = GetServices.shared.getAllCountry()
         return observer
     }
    
    
    
}
