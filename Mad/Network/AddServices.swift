//
//  AddServices.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

struct AddServices {
    static let shared = AddServices()

    
    
    
    //MARK:- POSt  favourit
    func addToFavourite(param : [String :Any]) -> Observable<FavouriteModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.addToFavourite
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(FavouriteModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    func shareProject(param : [String :Any]) -> Observable<ShareModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.shareProject
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ShareModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    //MARK:- POSt  favourit
    func addProductToFavourite(param : [String :Any]) -> Observable<ProductFavouriteModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.addProductToFavourite
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ProductFavouriteModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    
    //MARK:- POSt  favourit
    func addArtistToFavourite(param : [String :Any]) -> Observable<ArtistFavouriteModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.addArtistToFavourite
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ArtistFavouriteModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    func shareProduct(param : [String :Any]) -> Observable<ShareModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.shareProduct
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ShareModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func addVideoToFavourite(param : [String :Any]) -> Observable<VideoFavouriteMdel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.addVideoToFavourite
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(VideoFavouriteMdel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    
    
    func shareVideo(param : [String :Any]) -> Observable<ShareModel> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.shareVideo
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ShareModel.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
        
    func createProduct(image: [UIImage],params: [String : Any]) -> Observable<AddProductModelJson> {
          return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.createProduct
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
              Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
                
                for photo in image{
                    if let data = photo.jpegData(compressionQuality: 0.5) {
                          form.append(data, withName: "photos[]", fileName: "image.jpeg", mimeType: "image/jpeg")
                      }
                }
                
                for (key, value) in params {
                    if let temp = value as? String {
                        form.append(temp.data(using: .utf8)!, withName: key)
                     }
                
                    if let temp = value as? Int {
                        form.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                                  temp.forEach({ element in
                                      let keyObj = key + "[]"
                                          if let num = element as? Int {
                                              let value = "\(num)"
                                            form.append(value.data(using: .utf8)!, withName: keyObj)
                                      }
                                  })
                              }
                    
                }
                
              }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: headers) { (result: SessionManager.MultipartFormDataEncodingResult) in
                      switch result {
                  case .failure(let error):
                      print(error.localizedDescription)
                      observer.onError(error)
                  case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                      upload.uploadProgress { (progress) in
                        print("Image Uploading Progress: \(progress.fractionCompleted)")
                    }.responseJSON { (response: DataResponse<Any>) in
               do {
                      let data = try JSONDecoder().decode(AddProductModelJson.self, from: response.data!)
                        print(data)
                          observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                          observer.onError(error)
                      }
                    }
                  }
               }
              return Disposables.create()
          }
      }//END of POST Register

    
    
    func createProject(image: UIImage,params: [String : Any]) -> Observable<AddProductModelJson> {
          return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.createProject
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
              Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
                if let data = image.jpegData(compressionQuality: 0.5) {
                  form.append(data, withName: "image_url", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in params {
                    if let temp = value as? String {
                        form.append(temp.data(using: .utf8)!, withName: key)
                     }
                
                    if let temp = value as? Int {
                        form.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                                  temp.forEach({ element in
                                      let keyObj = key + "[]"
                                          if let num = element as? Int {
                                              let value = "\(num)"
                                            form.append(value.data(using: .utf8)!, withName: keyObj)
                                      }
                                     
                                  })
                        }
                    
                    if let temp = value as? NSDictionary {
                      for (key, value) in temp {
                      form.append("\(value)".data(using: .utf8)!, withName: key as! String)
                      }
                  }
                }
              }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: headers) { (result: SessionManager.MultipartFormDataEncodingResult) in
                      switch result {
                  case .failure(let error):
                      print(error.localizedDescription)
                      observer.onError(error)
                  case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                      upload.uploadProgress { (progress) in
                        print("Image Uploading Progress: \(progress.fractionCompleted)")
                    }.responseJSON { (response: DataResponse<Any>) in
               do {
                      let data = try JSONDecoder().decode(AddProductModelJson.self, from: response.data!)
                        print(data)
                        observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                          observer.onError(error)
                      }
                    }
                  }
               }
              return Disposables.create()
          }
      }//END of POST Register
    
    
    func addCompete(file: UIImage,params: [String : Any]) -> Observable<AddProductModelJson> {
          return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.addCompetition
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
              Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
                if let data = file.jpegData(compressionQuality: 0.5) {
                  form.append(data, withName: "introduction_file", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                for (key, value) in params {
                    if let temp = value as? String {
                        form.append(temp.data(using: .utf8)!, withName: key)
                     }
                    if let temp = value as? Int {
                        form.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                }
              }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: headers) { (result: SessionManager.MultipartFormDataEncodingResult) in
                      switch result {
                  case .failure(let error):
                      print(error.localizedDescription)
                      observer.onError(error)
                  case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                      upload.uploadProgress { (progress) in
                        print("Image Uploading Progress: \(progress.fractionCompleted)")
                    }.responseJSON { (response: DataResponse<Any>) in
               do {
                      let data = try JSONDecoder().decode(AddProductModelJson.self, from: response.data!)
                        print(data)
                        observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                          observer.onError(error)
                      }
                    }
                  }
               }
              return Disposables.create()
          }
      }//END of POST Register
    
    
    //MARK:- POSt  favourit
    func voteCompetition(param : [String :Any]) -> Observable<CompetitionsDetailsModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.voteCompetition
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(CompetitionsDetailsModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }

    
    func addNewVisit(param : [String :Any]) -> Observable<AddProductModelJson> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.addNewVisit
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
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
       }
    
    
    func removeVisit(param : [String :Any]) -> Observable<AddProductModelJson> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.removeVisit
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
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
       }
    
    
    func addToCart(param : [String :Any]) -> Observable<AddProductModelJson> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.addToCart
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
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
       }
    
    
    func updateCartProduct(param : [String :Any]) -> Observable<CartModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.updateCartProduct
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
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
    
    
    func updateCartDetails(param : [String :Any]) -> Observable<CartDetailsModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.updateCartDetails
            
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
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
    
    func addComment(param : [String :Any]) -> Observable<ReviewModelJson> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.addComment
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ReviewModelJson.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    

    func updateBanner(image: UIImage) -> Observable<AddProductModelJson> {
          return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.updateBanner
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
              Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
                if let data = image.jpegData(compressionQuality: 0.5) {
                    form.append(data, withName: "banner_img", fileName: "image.jpeg", mimeType: "image/jpeg")
                    }
                
              }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: headers) { (result: SessionManager.MultipartFormDataEncodingResult) in
                      switch result {
                  case .failure(let error):
                      print(error.localizedDescription)
                      observer.onError(error)
                  case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                      upload.uploadProgress { (progress) in
                        print("Image Uploading Progress: \(progress.fractionCompleted)")
                    }.responseJSON { (response: DataResponse<Any>) in
               do {
                      let data = try JSONDecoder().decode(AddProductModelJson.self, from: response.data!)
                        print(data)
                          observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                          observer.onError(error)
                      }
                    }
                  }
               }
              return Disposables.create()
          }
      }//END

    
    func updateProfile(image: UIImage) -> Observable<AddProductModelJson> {
          return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.updateProfile
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
              Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
                if let data = image.jpegData(compressionQuality: 0.5) {
                    form.append(data, withName: "profile_picture", fileName: "image.jpeg", mimeType: "image/jpeg")
                    }
                
              }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: headers) { (result: SessionManager.MultipartFormDataEncodingResult) in
                      switch result {
                  case .failure(let error):
                      print(error.localizedDescription)
                      observer.onError(error)
                  case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                      upload.uploadProgress { (progress) in
                        print("Image Uploading Progress: \(progress.fractionCompleted)")
                    }.responseJSON { (response: DataResponse<Any>) in
               do {
                      let data = try JSONDecoder().decode(AddProductModelJson.self, from: response.data!)
                        print(data)
                          observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                          observer.onError(error)
                      }
                    }
                  }
               }
              return Disposables.create()
          }
      }
}
