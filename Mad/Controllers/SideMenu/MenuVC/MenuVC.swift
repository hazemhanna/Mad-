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
        
    var active = Helper.getIsActive() ?? false
    var disposeBag = DisposeBag()
    var cartVM = CartViewModel()
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    let type = Helper.getType() ?? false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if active {
            userView.isHidden = true
            artistView.isHidden = false
        }else{
            userView.isHidden = false
            artistView.isHidden = true
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
    
    @IBAction func upgradeButton(sender: UIButton) {
        let vc = EditMyProfileVc.instantiateFromNib()
        vc?.upgrad = true
        self.navigationController?.pushViewController(vc!, animated: true)
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
    
    @IBAction func termsAction(sender: UIButton) {
         let url = "https://www.howmadareyou.com/terms-of-use/"
        Helper.UIApplicationURL.openUrl(url: url)
    }
  
    @IBAction func policyAction(sender: UIButton) {
         let url = "https://www.howmadareyou.com/privacy-and-policies/"
        Helper.UIApplicationURL.openUrl(url: url)
    }
    
    
    @IBAction func logOutAction(sender: UIButton) {
        
        let alert = UIAlertController(title: "LogOut", message: "Are you sure", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            Helper.LogOut()
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
        }
        yesAction.setValue(#colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1), forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        cancelAction.setValue(#colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1), forKey: "titleTextColor")
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
