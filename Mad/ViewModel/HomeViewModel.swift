//
//  HomeViewModel.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//



import Foundation
import RxSwift
import SVProgressHUD


struct HomeViewModel {
    
    
    var data = PublishSubject<[String]>()
    var liveData = PublishSubject<[String]>()
    var title = PublishSubject<[String]>()

    func fetchMainData(data: [String]) {
        self.data.onNext(data)
       }
    
 
    func fetchliveData(data: [String]) {
        self.liveData.onNext(data)
       }
    
    
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
