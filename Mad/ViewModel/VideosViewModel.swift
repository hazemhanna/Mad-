//
//  VideosViewModel.swift
//  Mad
//
//  Created by MAC on 13/05/2021.
//

import Foundation
import RxSwift
import SVProgressHUD

struct VideosViewModel {
    
    
    var title = PublishSubject<[String]>()

    func fetchtitle(data: [String]) {
        self.title.onNext(data)
       }
    
    
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    

    func getCategories() -> Observable<CategoryModel> {
         let observer = GetServices.shared.getAllCategories()
         return observer
     }
    
    func getAllVideos() -> Observable<VideoModelJson> {
        let observer = GetServices.shared.getAllVideo()
         return observer
     }
    
    func getVideoDetails(id :Int) -> Observable<VideoDetailsModelJson> {
        let params: [String: Any] = [
            "id": id
        ]
        let observer = GetServices.shared.getVideotDetails(param : params)
         return observer
     }
    
    func addToFavourite(videoId : Int,Type : Bool) -> Observable<ProductFavouriteModel> {
        let params: [String: Any] = [
            "video_id": videoId,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addProductToFavourite(param : params)
         return observer
     }
    
    func shareVideo(videoId : Int) -> Observable<ShareModel> {
        let params: [String: Any] = [
            "video_id": videoId,
            ]
        let observer = AddServices.shared.shareProduct(param : params)
         return observer
     }
    
}
