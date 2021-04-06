//
//  AdsViewModel.swift
//  Mad
//
//  Created by MAC on 05/04/2021.
//



import Foundation
import RxSwift
import SVProgressHUD


struct AdsViewModel {
    
    
    var data = PublishSubject<[String]>()
  
    func fetchAds(data: [String]) {
        self.data.onNext(data)
       }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
}
