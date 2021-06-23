//
//  SearchViewModel.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//

import Foundation
import RxSwift
import SVProgressHUD

struct SearchViewModel {
    
    
    var title = PublishSubject<[String]>()

    func fetchtitle(data: [String]) {
        self.title.onNext(data)
       }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
}
