//
//  ProjectViewModel.swift
//  Mad
//
//  Created by MAC on 04/06/2021.
//



import Foundation
import RxSwift
import SVProgressHUD

struct ProjectViewModel {
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
//    func CreatProject(
//                      title :String,
//                      content :String,
//                      short_description:String,
//                      summary:String,
//                      image:UIImage,
//                      categories :[Int],
//                      products :[Int],
//                      artists :[Int],
//                      startDate :String,
//                      endDate :String,
//                      location :String,
//                     submit :String,
//                     packages: [String:Any]) -> Observable<AddProductModelJson> {
//        let params: [String: Any] = [
//            "title":title,
//            "categories": categories,
//            "content": content,
//            "short_description":short_description,
//            "summary":summary,
//            "image_url":image,
//            "start_date":startDate,
//            "end_date":endDate,
//            "products":products,
//            "location":location,
//            "type":type,
//            "packages":packages,
//            "associated_artists":artists,
//            "submit":submit
//        ]
//        let observer = AddServices.shared.createProduct(image: image,params : params)
//            return observer
//     }
    
    
    
    func getCategories() -> Observable<CategoryModel> {
         let observer = GetServices.shared.getAllCategories()
         return observer
     }
    
    func getAllArtist(pageNum :Int) -> Observable<ArtistModelJson> {
        let params: [String: Any] = [
            "page_number": pageNum
        ]
        let observer = GetServices.shared.getAllArtist(param : params)
         return observer
     }
    

}
