//
//  Authentication.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//


import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class Authentication {
    
    static let shared = Authentication()
        //MARK:- POST Register
        func postRegister(params: [String: Any]) -> Observable<RegisterModel> {
            return Observable.create { (observer) -> Disposable in
                let url = ConfigURLS.postRegister
                
                Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                    .validate(statusCode: 200..<300)
                    .responseJSON { (response: DataResponse<Any>) in
                        do {
                            let loginData = try JSONDecoder().decode(RegisterModel.self, from: response.data!)
                            observer.onNext(loginData)
                        } catch {
                            print(error.localizedDescription)
                            observer.onError(error)
                        }
                }
                return Disposables.create()
            }
        }//END of POST Register

    
    //MARK:- POST Login
    func postLogin(params: [String: Any]) -> Observable<RegisterModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postRegister
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let loginData = try JSONDecoder().decode(RegisterModel.self, from: response.data!)
                        observer.onNext(loginData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST Login
    
    //MARK:- POST Verfiy
    func postVerifyRegister(params: [String: Any]) -> Observable<RegisterModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.checkOtp
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let loginData = try JSONDecoder().decode(RegisterModel.self, from: response.data!)
                        observer.onNext(loginData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST Login
    
    
}
