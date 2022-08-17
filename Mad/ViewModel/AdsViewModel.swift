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
    
    
    var data = PublishSubject<[SplashModel]>()
  
    func fetchAds(data: [SplashModel]) {
        self.data.onNext(data)
       }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
}
