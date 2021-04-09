//
//  CategeoryViewModel.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import Foundation
import RxSwift
import SVProgressHUD

struct  CategeoryViewModel {
    
    var Categories = PublishSubject<[String]>()

    
    func fetchCategories(Categories: [String]) {
        self.Categories.onNext(Categories)
    }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    
}
