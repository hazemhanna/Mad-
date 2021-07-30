//
//  AddReviewVC.swift
//  Mad
//
//  Created by MAC on 09/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar
import Cosmos

class AddReviewVC: UIViewController {
    
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var titleTf: CustomTextField!
    @IBOutlet weak var commentTf: CustomTextField!
    
    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    var productId = Int()
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    @IBAction func submitButton(sender: UIButton) {
        if commentTf.text != ""{
            self.productVM.showIndicator()
            addComment(productId: productId, comment: commentTf.text ?? "" , rate: Int(rateView.rating))
        }else{
            self.showMessage(text: "write comment")
        }
        
    }
    
    
}


extension AddReviewVC {
    func addComment (productId : Int,comment:String,rate:Int) {
        productVM.addComment(productId: productId, comment: comment, rate: rate).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.productVM.dismissIndicator()

            self.navigationController?.popViewController(animated: true)
           }
       }, onError: { (error) in
        self.productVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
