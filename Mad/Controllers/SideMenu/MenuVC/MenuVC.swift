//
//  MenuVC.swift
//  Mad
//
//  Created by MAC on 04/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar


class MenuVC: UIViewController {

    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var artistView: UIView!
    @IBOutlet weak var titleLble: UILabel!
    @IBOutlet weak var cartCount: UILabel!

    var disposeBag = DisposeBag()
    var cartVM = CartViewModel()
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    let type = Helper.getType() ?? false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type {
            userView.isHidden = true
            artistView.isHidden = false
           // titleLble.text = "User menu"
        }else{
            userView.isHidden = false
            artistView.isHidden = true
          //  titleLble.text = "Artist menu"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = false
        }
        
        self.cartVM.showIndicator()
        getCart()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func myCartAction(sender: UIButton) {
        let main = MyCartVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func addressAction(sender: UIButton) {
        let main = AddressVC.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func myOrderAction(sender: UIButton) {
        let main = MyOrderVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func favouriteAction(sender: UIButton) {
        let main = FavouriteVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func paymentction(sender: UIButton) {
        let main = PaymentDetailsVC.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
}

extension MenuVC{
func getCart() {
    cartVM.getCart().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.cartVM.dismissIndicator()
        self.cartCount.text = "\(dataModel.data?.cardProducts?.count ?? 0)"
       }else{
        self.cartVM.dismissIndicator()
       }
   }, onError: { (error) in
    self.cartVM.dismissIndicator()
   }).disposed(by: disposeBag)
  }
}
