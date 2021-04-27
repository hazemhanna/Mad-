//
//  ProjectViewModel.swift
//  Mad
//
//  Created by MAC on 27/04/2021.
//


import Foundation
import RxSwift
import SVProgressHUD

struct ProductViewModel {
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getAllProduct(pageNum :Int) -> Observable<ProductModelJson> {
        let params: [String: Any] = [
            "page_number": pageNum
        ]
        let observer = GetServices.shared.getAllProduct(param : params)
         return observer
     }
    
    func getSuggested() -> Observable<SugessteProduct> {
         let observer = GetServices.shared.getSuggestedProduct()
         return observer
     }

    func getCategories() -> Observable<CategoryModel> {
         let observer = GetServices.shared.getAllCategories()
         return observer
     }
    
}
