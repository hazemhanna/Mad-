//
//  SearchViewModel.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//

import Foundation
import RxSwift
import SVProgressHUD

struct SearchViewModel {
    
    
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
    
    func getPopular() -> Observable<SearchModelJason> {
        let observer = GetServices.shared.popularSearch()
         return observer
     }
    
    func addNewVisit(section :String,id :Int) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "section": section,
            "object_id": id
        ]
         let observer = AddServices.shared.addNewVisit(param: params)
         return observer
     }
    
    
    func removeVisit(section :String,id :Int) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "section": section,
            "object_id": id
        ]
         let observer = AddServices.shared.removeVisit(param: params)
         return observer
     }
 
    func getSearchArtist(section : String,search:String,pageNum :Int) -> Observable<SearchArtistModel> {
        let params: [String: Any] = [
            "page_number": pageNum,
            "section":section,
            "search":search
        ]
        let observer = GetServices.shared.getSearchArtist(param : params)
         return observer
     }
    
    func getSearchTags(section : String,search:String,pageNum :Int) -> Observable<SearchTagsModel> {
        let params: [String: Any] = [
            "page_number": pageNum,
            "section":section,
            "search":search
        ]
        let observer = GetServices.shared.getSearchTags(param : params)
         return observer
     }

    
    func getSearchProduct(section : String,search:String,pageNum :Int) -> Observable<SearchProductModel> {
        let params: [String: Any] = [
            "page_number": pageNum,
            "section":section,
            "search":search
        ]
        let observer = GetServices.shared.getSearchProduct(param : params)
         return observer
     }

    
    func getSearchCompetitions(section : String,search:String,pageNum :Int) -> Observable<SearchCompetitionsModel> {
        let params: [String: Any] = [
            "page_number": pageNum,
            "section":section,
            "search":search
        ]
        let observer = GetServices.shared.getSearchCompetitons(param : params)
         return observer
     }

    
    
}
