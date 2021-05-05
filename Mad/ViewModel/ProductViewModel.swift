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
    

    func getTopProduct(id :Int,pageNum :Int) -> Observable<ProductModelJson> {
        let params: [String: Any] = [
            "page_number": pageNum,
            "category_id": id
        ]
        let observer = GetServices.shared.getTopProduct(param : params)
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
    
    func getTopProductDetails(id :Int) -> Observable<ProductDetailsModelJson> {
        let params: [String: Any] = [
            "id": id
        ]
        let observer = GetServices.shared.getProductDetails(param : params)
         return observer
     }
    
    
    func addToFavourite(productId : Int,Type : Bool) -> Observable<ProductFavouriteModel> {
        let params: [String: Any] = [
            "product_id": productId,
            "is_favorite": Type
            ]
        let observer = AddServices.shared.addProductToFavourite(param : params)
         return observer
     }
    
    
    func shareProduct(productId : Int) -> Observable<ShareModel> {
        let params: [String: Any] = [
            "product_id": productId,
            ]
        let observer = AddServices.shared.shareProduct(param : params)
         return observer
     }
    
}
