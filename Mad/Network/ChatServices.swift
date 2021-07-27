//
//  ChatServices.swift
//  Mad
//
//  Created by MAC on 27/07/2021.
//

import Foundation
import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class ChatServices {
    
    static let shared = ChatServices()

    func creatConverstion(param : [String :Any]) -> Observable<CreatConversationModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.creatConverstion
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(CreatConversationModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func getConversation() -> Observable<ConversationModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getAllConverstion
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
               Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(ConversationModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }

    func getMessages(param : [String :Any]) -> Observable<MessagesModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.getAllMessages
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
               Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(MessagesModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }
    
    func SendMessage(param : [String :Any]) -> Observable<MessagesModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.sendMessages
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
               Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(MessagesModelJSON.self, from: response.data!)
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
