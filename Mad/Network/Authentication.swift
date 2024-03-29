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
        func postRegister(params: [String: Any]) -> Observable<AuthModel> {
            return Observable.create { (observer) -> Disposable in
                let url = ConfigURLS.postRegister
                
                Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                    .validate(statusCode: 200..<300)
                    .responseJSON { (response: DataResponse<Any>) in
                        do {
                            let loginData = try JSONDecoder().decode(AuthModel.self, from: response.data!)
                            observer.onNext(loginData)
                        } catch {
                            print(error.localizedDescription)
                            observer.onError(error)
                        }
                }
                return Disposables.create()
            }
        }//END of POST Register

    //MARK:- POST Verfiy
    func postVerifyRegister(params: [String: Any]) -> Observable<VerifyModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.checkOtp
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let loginData = try JSONDecoder().decode(VerifyModel.self, from: response.data!)
                        observer.onNext(loginData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST Login
    
    
    
    //MARK:- POST Login
    func postLogin(params: [String: Any]) -> Observable<AuthRegisterModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.login
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let loginData = try JSONDecoder().decode(AuthRegisterModel.self, from: response.data!)
                        Helper.saveAlogin(token: loginData.data?.accessToken ?? "",email: loginData.data?.user?.userEmail ?? "", fName: loginData.data?.user?.firstName ?? "" ,lName : loginData.data?.user?.lastName ?? "",type:  loginData.data?.user?.madArtist ?? false, id: loginData.data?.user?.artistID ?? 0, isActive: loginData.data?.user?.activatedArtist ?? false, profile: loginData.data?.user?.profilPicture ?? "" ,completed : loginData.data?.user?.completed_profile ?? false)
                        observer.onNext(loginData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST Login
    
    //MARK:- POST CompleteProfile
    func postCompleteProfile(params: [String: Any]) -> Observable<AuthRegisterModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.completeRegister
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let loginData = try JSONDecoder().decode(AuthRegisterModel.self, from: response.data!)
                        observer.onNext(loginData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST CompleteProfile
    
    
    //MARK:- POST
    func postFCM(params: [String: Any]) -> Observable<AddProductModelJson> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.FCm
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(AddProductModelJson.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST CompleteProfile
    
    //MARK:- POST
    func resetPassword(params: [String: Any]) -> Observable<AddProductModelJson> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.resetPassword
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(AddProductModelJson.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST CompleteProfile
    
    //MARK:- POST
    func forgetPassword(params: [String: Any]) -> Observable<AddProductModelJson> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.forgetPassword
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(AddProductModelJson.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST CompleteProfile
    
    
    func hideProject(params: [String: Any]) -> Observable<ProjectDetailsModel> {
        return Observable.create { (observer) -> Disposable in
            let url = "http://mad.cnepho.com/api/project/hide"
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(ProjectDetailsModel.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST CompleteProfile
    
    func updateProfile(params: [String: Any]) -> Observable<ProfileModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.updateMyProfile
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(ProfileModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST CompleteProfile
    
    func upgradeMyProfile(params: [String: Any]) -> Observable<AddProductModelJson> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.upgradeMyProfile
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(AddProductModelJson.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST CompleteProfile
    

    func checkPassword(params: [String: Any]) -> Observable<CheckPasswordModelJson> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.checkPassword
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(CheckPasswordModelJson.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST CompleteProfile
    
    
}
