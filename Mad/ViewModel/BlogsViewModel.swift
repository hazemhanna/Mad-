//
//  BlogsViewModel.swift
//  Mad
//
//  Created by MAC on 14/07/2021.
//

import Foundation

import Foundation
import RxSwift
import SVProgressHUD


struct BlogsViewModel {
    
    
    
    
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
    
    func getBlogs(page : Int,catId : Int) -> Observable<BlogModelJSON> {
        let params = [
                "page_number": page,
                "category_id":catId
                ]
        
        let observer = GetServices.shared.getAllBlogs(param : params)
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
