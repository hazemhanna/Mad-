//
//  OrderViewModel.swift
//  Mad
//
//  Created by MAC on 04/08/2021.
//


import Foundation
import RxSwift
import SVProgressHUD

struct OrderViewModel {
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getOrders() -> Observable<OrderModelJSON> {
        let observer = GetServices.shared.getOrders()
         return observer
     }
    
    
    func getOrderDetails(id : Int) -> Observable<OrderDetailsModelJSON> {
        let params: [String: Any] = [
            "id": id,
            ]
        let observer = GetServices.shared.getOrderDetails(param : params)
         return observer
     }
    
    
}
