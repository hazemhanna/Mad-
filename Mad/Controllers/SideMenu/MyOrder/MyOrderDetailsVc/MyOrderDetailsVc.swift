//
//  MyOrderDetailsVc.swift
//  Mad
//
//  Created by MAC on 05/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class MyOrderDetailsVc: UIViewController {
    
    @IBOutlet weak var orderNumlLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var itemNumLbl: UILabel!
    @IBOutlet weak var itemCoupone: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productmage: UIImageView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistNameLbl: UILabel!
    

    var disposeBag = DisposeBag()
    var orderVM = OrderViewModel()
    var items = [Item]()
    var orderId = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        orderVM.showIndicator()
        getOrdersDetails(id : orderId)
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }

}

extension MyOrderDetailsVc {

    func getOrdersDetails(id : Int) {
    orderVM.getOrderDetails(id: id).subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.orderVM.dismissIndicator()
        let data = dataModel.data
        self.orderNumlLbl.text = "order #" + String(id)
        self.emailLbl.text = data?.email ?? ""
        self.mobileLbl.text =  ""
        self.addressLbl.text = data?.address ?? ""
        self.cityLbl.text = data?.city ?? ""
        self.countryLbl.text = data?.country ?? ""
        self.itemNumLbl.text = String(data?.items?.count ?? 0)
        self.itemCoupone.text =   ""
        self.totalLbl.text =  "$" + String(data?.totalPrice ?? 0 )
        self.projectNameLbl.text = data?.items?[0].product.title  ?? ""
        self.priceLbl.text = "$" + String(data?.items?[0].product.price  ?? 0)
        self.artistNameLbl.text = data?.items?[0].product.artist?.name  ?? ""
        
        if let productUrl = URL(string:  data?.items?[0].product.imageURL  ?? ""){
        self.productmage.kf.setImage(with: productUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
        if let artistImage = URL(string:  data?.items?[0].product.artist?.profilPicture  ?? ""){
        self.artistImage.kf.setImage(with: artistImage, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
     }
    },onError: { (error) in
    self.orderVM.dismissIndicator()
   }).disposed(by: disposeBag)
  }
}
