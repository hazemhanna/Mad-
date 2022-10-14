//
//  FavouriteViewModel.swift
//  Mad
//
//  Created by MAC on 04/08/2021.
//


import Foundation
import RxSwift
import SVProgressHUD

struct FavouriteViewModel {
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getFavourite() -> Observable<FavouriteModelJSON> {
        let observer = GetServices.shared.getFavourite()
         return observer
     }
    
    func productFavourite(productId : Int,Type : Bool) -> Observable<ProductFavouriteModel> {
        let params: [String: Any] = [
            "product_id": productId,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addProductToFavourite(param : params)
         return observer
     }

    func artistFavourite(artistId : Int,Type : Bool) -> Observable<ArtistFavouriteModel> {
        let params: [String: Any] = [
            "artist_id": artistId,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addArtistToFavourite(param : params)
         return observer
     }
    
    func projectFavourite(productID : Int,Type : Bool) -> Observable<FavouriteModel> {
        let params: [String: Any] = [
            "project_id": productID,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addToFavourite(param : params)
         return observer
     }
    
    func addVideoFavourite(videoId : Int,Type : Bool) -> Observable<VideoFavouriteMdel> {
        let params: [String: Any] = [
            "video_id": videoId,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addVideoToFavourite(param : params)
         return observer
     }
    
}
