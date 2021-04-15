//
//  GetServices.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class GetServices {
    
    static let shared = GetServices()
    
    //MARK:- GET All Categories
    func getAllCategories() -> Observable<CategoryModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getCategeory
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let CategoriesData = try JSONDecoder().decode(CategoryModel.self, from: response.data!)
                        observer.onNext(CategoriesData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of GET All Categories
    
    
 //MARK:- GET All Country
    func getAllCountry() -> Observable<CountryModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getCountry
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let CountryData = try JSONDecoder().decode(CountryModel.self, from: response.data!)
                        observer.onNext(CountryData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of GET All Country
    
    //MARK:- GET All Project
    func getAllProject(param : [String :Any]) -> Observable<ProjectMainModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getProject
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let CountryData = try JSONDecoder().decode(ProjectMainModel.self, from: response.data!)
                           observer.onNext(CountryData)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }//END of GET All Project
    
}
