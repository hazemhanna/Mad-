//
//  SplashViewModel.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//

import Foundation
import RxSwift
import SVProgressHUD

struct  SplashViewModel {
    
    var data = PublishSubject<[SplashModel]>()

    
    func fetchsplash(splash: [SplashModel]) {
        self.data.onNext(splash)
    }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    
}
