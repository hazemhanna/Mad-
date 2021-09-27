//
//  ChatViewModel.swift
//  Mad
//
//  Created by MAC on 26/07/2021.
//




import Foundation
import RxSwift
import SVProgressHUD

struct ChatViewModel {
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getSearchArtist(section : String,search:String,pageNum :Int) -> Observable<SearchArtistModel> {
        let params: [String: Any] = [
            "page_number": pageNum,
            "section":section,
            "search":search
        ]
        let observer = GetServices.shared.getSearchArtist(param : params)
         return observer
     }
    
    
    func getArtistProduct() -> Observable<ArtistProductModel> {
         let observer = GetServices.shared.getArtistProduct()
         return observer
     }
    
    
    func getArtistProfile(artistId : Int) -> Observable<ArtistProfileModelJSON> {
        let params: [String: Any] = [
            "id": artistId,
            ]
        let observer = GetServices.shared.getArtistProfile(param : params)
         return observer
     }
    
    
    func creatConversation(subject:String,artistId : Int,subjectId : Int) -> Observable<CreatConversationModelJSON> {
        let params: [String: Any] = [
            "subject": subject,
            "contact_artist": artistId,
            "artist_object": subjectId,
            ]
        let observer = ChatServices.shared.creatConverstion(param : params)
         return observer
     }
    
 
    func getConversation() -> Observable<ConversationModelJSON> {
        let observer = ChatServices.shared.getConversation()
         return observer
     }
    
    
    func getMessages(convId : Int) -> Observable<MessagesModelJSON> {
        let params: [String: Any] = [
            "conversation_id": convId
            ]
        let observer = ChatServices.shared.getMessages(param : params)
         return observer
     }

    func sendMessages(content:String,convId : Int) -> Observable<MessagesModelJSON> {
        let params: [String: Any] = [
            "content": content,
            "conversation_id": convId
            ]
        let observer = ChatServices.shared.SendMessage(param : params)
         return observer
     }
    
    
    func getNotifications() -> Observable<NotificationModelJSON> {
        let observer = GetServices.shared.getNotifications()
         return observer
     }
    
    
    func getCategories() -> Observable<CategoryModel> {
         let observer = GetServices.shared.getAllCategories()
         return observer
     }
    
}
