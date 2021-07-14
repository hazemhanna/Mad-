//
//  BlogsViewModel.swift
//  Mad
//
//  Created by MAC on 14/07/2021.
//

import Foundation
import RxSwift
import SVProgressHUD

struct BlogsViewModel {
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }

    
    func getCategories() -> Observable<CategoryModel> {
         let observer = GetServices.shared.getAllCategories()
         return observer
     }
    
    func getBlogs(page : Int,catId : Int) -> Observable<BlogModelJSON> {
        var params: [String: Any] = [:]
        if catId != 0{
            params = [
                "page_number": page,
                "category_id":catId
                ]
        }else{
            params = [
                "page_number": page,
                ]
        }
        
        let observer = GetServices.shared.getAllBlogs(param : params)
         return observer
     }
    
    
    func getBlogsDetails(blogId : Int) -> Observable<BlogDetailsModelJSON> {
        let params: [String: Any] = [
            "id": blogId,
            ]
        let observer = GetServices.shared.getBlogsDetails(param : params)
         return observer
     }
    
    
    
    func shareBlogs(blogsId : Int) -> Observable<ShareModel> {
        let params: [String: Any] = [
            "project_id": blogsId,
            ]
        let observer = AddServices.shared.shareProject(param : params)
         return observer
     }
    
}
