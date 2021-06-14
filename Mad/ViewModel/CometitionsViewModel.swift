//
//  CometitionsViewModel.swift
//  Mad
//
//  Created by MAC on 14/06/2021.
//

import Foundation


import Foundation
import RxSwift
import SVProgressHUD

struct CometitionsViewModel {
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getAllCompetions(search : String,step:String,pageNum :Int) -> Observable<CompetitionsModelJSON> {
        let params: [String: Any] = [
            "step": step,
            "page_number":pageNum,
            "search":search
        ]
         let observer = GetServices.shared.getAllCompetition(param: params)
         return observer
     }
    
    
    
}
