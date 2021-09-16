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
    var countries = PublishSubject<[String]>()

    
    func fetchCategories(Categories: [Category]) {
          self.categories.onNext(Categories)
      }
    
    func fetchCountries(Countries: [String]) {
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
    func attemptToCompleteProfile(categories:[Int],type : Bool) -> Observable<AuthRegisterModel> {
        let bindedEmail = Helper.getUserEmail() ?? ""
        let bindedPassword =  Helper.getUserPass() ?? ""
        let firstName =  Helper.getUserFirstName() ?? ""
        let  LastName =  Helper.getUserLastName() ?? ""
        let age =  Helper.getUserAge() ?? ""
        let country = Helper.getUserCountry() ?? ""
        let type =  type
        let code =  Helper.getUserCode() ?? ""
        
        let params: [String: Any] = [
            "email": bindedEmail,
            "password": bindedPassword,
            "password_confirmation": bindedPassword,
            "first_name": firstName,
            "last_name": LastName,
            "age": age,
            "country": country,
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
    
    
    func postFCM(token:String) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "token": token
            ]
        let observer = Authentication.shared.postFCM(params: params)
        return observer
    }
    
    
    func resetPassword() -> Observable<AddProductModelJson> {
        let bindedEmail = Helper.getUserEmail() ?? ""
        let bindedPassword =  Helper.getUserPass() ?? ""
        let code =  Helper.getUserCode() ?? ""
         let params: [String: Any] = [
            "email": bindedEmail,
            "password": bindedPassword,
            "password_confirmation": bindedPassword,
            "verification_code": code
           ]
        
        let observer = Authentication.shared.resetPassword(params: params)
        return observer
    }
    
    func forgetPassword() -> Observable<AddProductModelJson> {
        let bindedEmail = Helper.getUserEmail() ?? ""
         let params: [String: Any] = [
            "email": bindedEmail,
           ]
        let observer = Authentication.shared.forgetPassword(params: params)
        return observer
    }
    
    
    
    
    
}
