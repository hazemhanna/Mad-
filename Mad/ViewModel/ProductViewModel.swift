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
            "page_number": pageNum,
        ]
        let observer = GetServices.shared.getAllProduct(param : params)
         return observer
     }
    

    func getAllProductWithCat(pageNum :Int,catId : Int) -> Observable<ProductModelJson> {
        let params: [String: Any] = [
            "page_number": pageNum,
            "category_id":catId
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
         let observer = GetServices.shared.getProductCategories()
         return observer
     }
    
    func getTopProductDetails(id :Int) -> Observable<ProductDetailsModelJson> {
        let params: [String: Any] = [
            "id": id
        ]
        let observer = GetServices.shared.getProductDetails(param : params)
         return observer
     }
    
    func addToCart(id :Int,quantity : Int) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "id": id,
            "quantity": quantity
        ]
         let observer = AddServices.shared.addToCart(param: params)
         return observer
     }
    
    
    
    func getCart() -> Observable<CartModelJSON> {
         let observer = GetServices.shared.getCart()
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
    
    func CreatProduct(categories :[Int],
                      title :String,
                      short_description:String,
                      description:String,
                      materials: String,
                      length: Int,
                      width: Int,
                      height: Int,
                      weight: Int,
                      type: String,
                      price:Int,
                      price_eur:Int,
                      quantity:Int,
                      quantity_limitation:String,
                      delivery:Int,
                      delivery_index:String,
                      photos:[UIImage]) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "categories": categories,
            "title": title,
            "short_description":short_description,
            "description":description,
            "materials":materials,
            "length":length,
            "width":width,
            "height":height,
            "weight":weight,
            "type":type,
            "price":price,
            "price_eur":price_eur,
            "quantity":quantity,
            "quantity_limitation":quantity_limitation,
            "delivery":delivery,
            "delivery_index":delivery_index,
        ]
        let observer = AddServices.shared.createProduct(image: photos,params : params)
            return observer
     }
    
    func getProductCategories() -> Observable<CategoryModel> {
         let observer = GetServices.shared.catProduct()
         return observer
     }
    
    func addComment(productId : Int,comment:String,rate:Int) -> Observable<ReviewModelJson> {
        let params: [String: Any] = [
            "product_id": productId,
            "comment": comment,
            "rate": rate]
        let observer = AddServices.shared.addComment(param : params)
         return observer
     }
    
      func updateCart(id :Int,quantity : Int) -> Observable<CartModelJSON> {
          let params: [String: Any] = [
              "id": id,
              "quantity": quantity
          ]
           let observer = AddServices.shared.updateCartProduct(param: params)
           return observer
       }
      
    
}
