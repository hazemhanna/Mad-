//
//  CartViewModel.swift
//  Mad
//
//  Created by MAC on 06/07/2021.
//


import Foundation
import RxSwift
import SVProgressHUD

struct CartViewModel {
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    

   
    func addToCart(id :Int,quantity : Int) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "id": id,
            "quantity": quantity
        ]
         let observer = AddServices.shared.addToCart(param: params)
         return observer
     }
    
    
     func updateCart(id :Int,quantity : Int) -> Observable<AddProductModelJson> {
         let params: [String: Any] = [
             "id": id,
             "quantity": quantity
         ]
          let observer = AddServices.shared.updateCartProduct(param: params)
          return observer
      }
     
    
    func updateCartDetails(competitionId :Int,
                      fName :String,
                      lName :String,
                      phone:String,
                      email:String,
                      country:String,
                      company_name:String,
                      street_address:String,
                      city:String,
                      state:String,
                      postcode:String,
                      other_note:String ) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "first_name": fName,
            "last_name":lName,
            "company_name":company_name,
            "phone": phone,
            "email":email,
            "country":country,
            "street_address":street_address,
            "city":city,
            "state":state,
            "postcode":postcode,
            "other_note":other_note]
        let observer = AddServices.shared.updateCartDetails(param: params)
            return observer
     }
    
    func getCart() -> Observable<CartModelJSON> {
         let observer = GetServices.shared.getCart()
         return observer
     }
    
    func getCartDetials() -> Observable<CartDetailsModelJSON> {
         let observer = GetServices.shared.getCartDetails()
         return observer
     }
    
    
}
