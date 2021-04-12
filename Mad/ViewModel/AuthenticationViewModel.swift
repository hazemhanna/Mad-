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

    var categories = PublishSubject<[Category]>()
    var countries = PublishSubject<[Country]>()

    
    func fetchCategories(Categories: [Category]) {
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
    func attemptToRegister(bindedEmail:String) -> Observable<AuthModel> {
        let params: [String: Any] = [
            "email": bindedEmail
            ]
        let observer = Authentication.shared.postRegister(params: params)
        return observer
    }
    
    
    //MARK:- Attempt to register
    func attemptToVerify (bindedEmail:String,bindedCode:String) -> Observable<VerifyModel> {
        let params: [String: Any] = [
            "email": bindedEmail,
            "verification_code": bindedCode
            ]
        let observer = Authentication.shared.postVerifyRegister(params: params)
        return observer
    }

    //MARK:- Attempt to Login
    func attemptToCompleteProfile(categories:[Int]) -> Observable<AuthRegisterModel> {
        let bindedEmail = Helper.getUserEmail() ?? ""
        let bindedPassword =  Helper.getUserPass() ?? ""
        let firstName =  Helper.getUserFirstName() ?? ""
        let  LastName =  Helper.getUserLastName() ?? ""
        let age =  Helper.getUserAge() ?? ""
        let countryId = Helper.getUserCountry() ?? 0
        let type =  Helper.getUserType() ?? 1
        let code =  Helper.getUserCode() ?? ""
        
        let params: [String: Any] = [
            "email": bindedEmail,
            "password": bindedPassword,
            "password_confirmation": bindedPassword,
            "first_name": firstName,
            "last_name": LastName,
            "age": age,
            "country_id": countryId,
            "mad_artist": type,
            "verification_code": code,
            "categories": categories,
           ]
        
        let observer = Authentication.shared.postCompleteProfile(params: params)
        return observer
    }
    
    
    
    //MARK:- Attempt to Login
    func attemptToLogin(bindedEmail:String,bindedPassword:String) -> Observable<AuthRegisterModel> {
        let params: [String: Any] = [
            "email": bindedEmail,
            "password": bindedPassword
            ]
        let observer = Authentication.shared.postLogin(params: params)
        return observer
    }
    
    func getCategories() -> Observable<CategoryModel> {
         let observer = GetServices.shared.getAllCategories()
         return observer
     }
    
    func getAllCountries() -> Observable<CountryModel> {
         let observer = GetServices.shared.getAllCountry()
         return observer
     }
    
}
