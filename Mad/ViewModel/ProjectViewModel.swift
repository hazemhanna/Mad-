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
    
    func CreatProject(
                      title :String,
                      content :String,
                      short_description:String,
                      summary:String,
                      image:UIImage,
                      categories :[Int],
                      products :[Int],
                      artists :[Int],
                      startDate :String,
                      endDate :String,
                      location :String,
                     submit :String,
                     packages: [[String:String]]) -> Observable<AddProductModelJson> {
        let params: [String: Any] = [
            "title":title,
            "categories": categories,
            "content": content,
            "short_description":short_description,
            "summary":summary,
            "start_date":startDate,
            "end_date":endDate,
            "products":products,
            "location":location,
            "packages":packages,
            "associated_artists":artists,
            "submit":submit
        ]
        let observer = AddServices.shared.createProject(image: image,params : params)
            return observer
     }
    
    func getCategories() -> Observable<CategoryModel> {
         let observer = GetServices.shared.getAllCategories()
         return observer
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
    
    
    func getAllCountries() -> Observable<CountryModel> {
         let observer = GetServices.shared.getAllCountry()
         return observer
     }
    
    
}
