//
//  AuthenticationViewModel.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import Foundation
import RxSwift
import SVProgressHUD


struct AuthenticationViewModel {
    var email = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    var first_name = BehaviorSubject<String>(value: "")
    var last_name = BehaviorSubject<String>(value: "")
    var categories = PublishSubject<[Categeory]>()
    var countries = PublishSubject<[Country]>()

    func fetchCategories(Categories: [Categeory]) {
          self.categories.onNext(Categories)
      }
    
    func fetchCountries(Countries: [Country]) {
          self.countries.onNext(Countries)
      }
   
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
 
    //MARK:- Attempt to register
    func attemptToRegister(bindedEmail:String) -> Observable<RegisterModel> {
        let params: [String: Any] = [
            "email": bindedEmail
            ]
        let observer = Authentication.shared.postRegister(params: params)
        return observer
    }
    
    
    //MARK:- Attempt to register
    func attemptToVerify (bindedEmail:String,bindedCode:String) -> Observable<RegisterModel> {
        let params: [String: Any] = [
            "email": bindedEmail,
            "verification_code": bindedCode
            ]
        let observer = Authentication.shared.postVerifyRegister(params: params)
        return observer
    }

    
    //MARK:- Attempt to Login
    func attemptToLogin(bindedEmail:String,bindedPassword:String) -> Observable<RegisterModel> {
        let params: [String: Any] = [
            "email": bindedEmail,
            "password": bindedPassword
            ]
        let observer = Authentication.shared.postLogin(params: params)
        return observer
    }
    
    func getCategories() -> Observable<CategeoryModel> {
         let observer = GetServices.shared.getAllCategories()
         return observer
     }
    
    func getAllCountries() -> Observable<CountryModel> {
         let observer = GetServices.shared.getAllCountry()
         return observer
     }
    
}
