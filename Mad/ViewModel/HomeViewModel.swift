//
//  HomeViewModel.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//



import Foundation
import RxSwift
import SVProgressHUD


struct HomeViewModel {
    
    
    var data = PublishSubject<[String]>()
    var liveData = PublishSubject<[String]>()
    var title = PublishSubject<[String]>()

    func fetchMainData(data: [String]) {
        self.data.onNext(data)
       }
    
 
    func fetchliveData(data: [String]) {
        self.liveData.onNext(data)
       }
    
    
    func fetchtitle(data: [String]) {
        self.title.onNext(data)
       }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getAllProject(page : Int) -> Observable<ProjectMainModel> {
        let params: [String: Any] = [
            "page_number": page
            ]
        let observer = GetServices.shared.getAllProject(param : params)
         return observer
     }
    
    func getCategories() -> Observable<CategoryModel> {
         let observer = GetServices.shared.getAllCategories()
         return observer
     }
    
    
    func addToFavourite(productID : Int,Type : Bool) -> Observable<FavouriteModel> {
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
    
    
    func getProjectDetails(productID : Int) -> Observable<ProjectDetailsModel> {
        let params: [String: Any] = [
            "id": productID,
            ]
        let observer = GetServices.shared.getProjectDetails(param : params)
         return observer
     }
    
    
    
    
    
}
