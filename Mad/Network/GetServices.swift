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
    
    static var languageKey :String {
        return LanguageHelper.sharedDelegate().getLanguage().apiKey()
    }
    
    func getAllCategories() -> Observable<CategoryModel> {
        return Observable.create { (observer) -> Disposable in
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey
            ]
            
            let url = ConfigURLS.getCategeory
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
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
    }
    
    
    func getProductCategories() -> Observable<CategoryModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getProductCategeory
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey
            ]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
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
    }
    func getProjectCategories() -> Observable<CategoryModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getProjectCategeory
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey
            ]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
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
    }
    func getBlogCategories() -> Observable<CategoryModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getBlogCategeory
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey
            ]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
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
    }
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
    }
    
    func getAllProject(param : [String :Any]) -> Observable<ProjectMainModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getProject
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey
            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ProjectMainModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    
    func getTopProject(param : [String :Any]) -> Observable<ProjectMainModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getProject
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey
            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ProjectMainModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getProjectDetails(param : [String :Any]) -> Observable<ProjectDetailsModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getProjectDetails
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
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
       }
    
    func getAllArtist(param : [String :Any]) -> Observable<ArtistsMainModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getAllArtist
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ArtistsMainModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getSuggested() -> Observable<SuggestedModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getSuggested
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(SuggestedModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getTopArtist(param : [String :Any],catId : Int) -> Observable<ArtistsMainModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getAllArtist + "?category_id=\(catId)"
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ArtistsMainModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    func getArtistProfile(param : [String :Any]) -> Observable<ArtistProfileModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getArtistProfile
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ArtistProfileModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getAllProduct(param : [String :Any]) -> Observable<ProductModelJson> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getAllProduct
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ProductModelJson.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getTopProduct(param : [String :Any]) -> Observable<ProductModelJson> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getAllProduct
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ProductModelJson.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getSuggestedProduct() -> Observable<SugessteProduct> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getSuggestedProduct
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(SugessteProduct.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getProductDetails(param : [String :Any]) -> Observable<ProductDetailsModelJson> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getProductDetails
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ProductDetailsModelJson.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getAllVideo() -> Observable<VideoModelJson> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getAllvideos
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(VideoModelJson.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }

    func getVideotDetails(param : [String :Any]) -> Observable<VideoDetailsModelJson> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getVideoDetails
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(VideoDetailsModelJson.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    

    func catProduct() -> Observable<CategoryModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.catProduct
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
    }
    
    
    
    
    func getArtistProduct() -> Observable<ArtistProductModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.artistProduct
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ArtistProductModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
 
    
    func getAllCompetition(param : [String :Any]) -> Observable<CompetitionsModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getAllCompetition
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(CompetitionsModelJSON.self, from: response.data!)
                        print(data)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    
    func getCompetitionDetails(param : [String :Any]) -> Observable<CompetitionsDetailsModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getCompetitionDetails
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(CompetitionsDetailsModelJSON.self, from: response.data!)
                        print(data)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
 
    func aboutCompetition() -> Observable<AboutCompetitionsModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.aboutCompetition
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(AboutCompetitionsModelJSON.self, from: response.data!)
                        print(data)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    
 
    func popularSearch() -> Observable<SearchModelJason> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.popularSearch
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(SearchModelJason.self, from: response.data!)
                        print(data)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getSearchArtist(param : [String :Any]) -> Observable<SearchArtistModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.search
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(SearchArtistModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getSearchTags(param : [String :Any]) -> Observable<SearchTagsModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.search
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(SearchTagsModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    
    func getSearchCompetitons(param : [String :Any]) -> Observable<SearchCompetitionsModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.search
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(SearchCompetitionsModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    func getSearchProduct(param : [String :Any]) -> Observable<SearchProductModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.search
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(SearchProductModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
   
    
    func getCart() -> Observable<CartModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getCart
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(CartModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }

    
    func getCartDetails() -> Observable<CartDetailsModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getCartDetails
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(CartDetailsModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
   
    func getOrders() -> Observable<OrderModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getOrders
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(OrderModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    func getOrderDetails(param : [String :Any]) -> Observable<OrderDetailsModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getOrdersDetails
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(OrderDetailsModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }

    
    func getAllBlogs(param : [String :Any]) -> Observable<BlogModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.allBlogs
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(BlogModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getBlogsDetails(param : [String :Any]) -> Observable<BlogDetailsModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.blogDetails
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(BlogDetailsModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    
    func getNotifications() -> Observable<NotificationModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.notitfication
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(NotificationModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
    }
    
    func getFavourite() -> Observable<FavouriteModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getFavourite
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(FavouriteModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    
    
    func getMyProfile() -> Observable<ProfileModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getMyProfile
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)",
                "X-localization" : GetServices.languageKey

            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
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
       }
}
