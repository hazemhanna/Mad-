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
    
    func getAllArtist(pageNum :Int) -> Observable<ArtistModelJson> {
        let params: [String: Any] = [
            "page_number": pageNum
        ]
        let observer = GetServices.shared.getAllArtist(param : params)
         return observer
     }
    
    func getTopArtist(pageNum :Int,catId :Int) -> Observable<ArtistModelJson> {
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
    
}
