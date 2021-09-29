//
//  CometitionsViewModel.swift
//  Mad
//
//  Created by MAC on 14/06/2021.
//

import Foundation
import RxSwift
import SVProgressHUD

struct CometitionsViewModel {
    
    
    var title = PublishSubject<[String]>()

    func fetchtitle(data: [String]) {
        self.title.onNext(data)
       }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getAllCompetions(search : String,step:String,pageNum :Int) -> Observable<CompetitionsModelJSON> {
        let params: [String: Any] = [
            "step": step,
            "page_number":pageNum,
            "search":search
        ]
         let observer = GetServices.shared.getAllCompetition(param: params)
         return observer
     }
   
    func getCompetitionsDetails(id :Int) -> Observable<CompetitionsDetailsModelJSON> {
        let params: [String: Any] = [
            "id": id
        ]
         let observer = GetServices.shared.getCompetitionDetails(param: params)
         return observer
     }
    
    func CreateCompete(competitionId :Int,
                      fName :String,
                      lName :String,
                      phone:String,
                      email:String,
                      personal:String,
                      artist_name:String,
                      video_link:String,
                      project_description:String,
                      know_about:String,
                      submit:String,
                      file :UIImage) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "competition_id":competitionId,
            "last_name":lName,
            "first_name": fName,
            "phone": phone,
            "email":email,
            "introduction":personal,
            "artist_name":artist_name,
            "video_link":video_link,
            "project_description":project_description,
            "know_about":know_about,
            "submit":submit
        ]
        let observer = AddServices.shared.addCompete(file: file, params: params)
            return observer
     }
    
    
    func saveCompete(candidat_id :Int,competitionId :Int,
                      fName :String,
                      lName :String,
                      phone:String,
                      email:String,
                      personal:String,
                      artist_name:String,
                      video_link:String,
                      project_description:String,
                      know_about:String,
                      submit:String,
                      file :UIImage) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "candidat_id" :candidat_id,
            "competition_id":competitionId,
            "last_name":lName,
            "first_name": fName,
            "phone": phone,
            "email":email,
            "introduction":personal,
            "artist_name":artist_name,
            "video_link":video_link,
            "project_description":project_description,
            "know_about":know_about,
            "submit":submit
        ]
        let observer = AddServices.shared.addCompete(file: file, params: params)
            return observer
     }
    
    
    
    func voteCompetitions(competitionId :Int,candidateId :Int) -> Observable<CompetitionsDetailsModelJSON> {
        let params: [String: Any] = [
            "competition_id": competitionId,
            "candidate_id": candidateId
        ]
         let observer = AddServices.shared.voteCompetition(param: params)
         return observer
     }
    
    func getAboutCompetitionsl() -> Observable<AboutCompetitionsModelJSON> {
         let observer = GetServices.shared.aboutCompetition()
         return observer
     }
    
    
}
