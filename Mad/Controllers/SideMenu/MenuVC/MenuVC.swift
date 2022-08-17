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
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var savedBtn : UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var orderBtn : UIButton!
    @IBOutlet weak var addressBtn : UIButton!
    @IBOutlet weak var paymentBtn : UIButton!
    @IBOutlet weak var languageBtn : UIButton!
    @IBOutlet weak var termsUsebtn  : UIButton!
    @IBOutlet weak var  termsCondetionsBtn : UIButton!
    @IBOutlet weak var notiticationBtn : UIButton!
    @IBOutlet weak var  logoutBtn  : UIButton!
    @IBOutlet weak var aplicationSettingLbl : UILabel!
    @IBOutlet weak var paurchesedLbl : UILabel!
    
    var active = Helper.getIsActive() ?? false
    var disposeBag = DisposeBag()
    var cartVM = CartViewModel()
    var draftCompetitions = [Competitions]()
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
        
        titleLble.text = "title.menu".localized
        paurchesedLbl.text = "Purchase.menu".localized
        aplicationSettingLbl.text = "Application.Settings".localized
        upgradeBtn.setTitle("Upgrade.now".localized, for: .normal)
        savedBtn.setTitle("Saved.competitions".localized, for: .normal)
        favouriteBtn.setTitle("Favorites".localized, for: .normal)
        cartBtn.setTitle("MyCard".localized, for: .normal)
        orderBtn.setTitle("Myorders".localized, for: .normal)
        addressBtn.setTitle("Contact.Address.details".localized, for: .normal)
        paymentBtn.setTitle("Payment.details".localized, for: .normal)
        languageBtn.setTitle("Language".localized, for: .normal)
        termsUsebtn.setTitle("Terms.Use".localized, for: .normal)
        termsCondetionsBtn.setTitle("Terms.Conditions".localized, for: .normal)
        notiticationBtn.setTitle("Notifications".localized, for: .normal)
        logoutBtn.setTitle("Logout".localized, for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = false
        }
        
        self.cartVM.showIndicator()
        getCart()
        getProfile()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func upgradeButton(sender: UIButton) {
        let vc = EditMyProfileVc.instantiateFromNib()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func myCartAction(sender: UIButton) {
        let main = MyCartVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func addressAction(sender: UIButton) {
        let main = AddressVC.instantiateFromNib()
        main?.fromMenu = true
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func savedCompetions(sender: UIButton) {
     let main = DraftsVc.instantiateFromNib()
     main?.competitions = draftCompetitions
     main?.draftType = "competition"
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
    
    
    @IBAction func languageBtn(sender: UIButton) {
        if #available(iOS 13.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            return
        }
    }
    
    
    @IBAction func currencyBtn(sender: UIButton) {
        let main = CurrencyViewController.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func changePassBtn(sender: UIButton) {
        let main = ChangePssswordVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func logOutAction(sender: UIButton) {
        
        let alert = UIAlertController(title: "Log Out", message: "Are you sure", preferredStyle: .alert)
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
    
    
    func getProfile() {
        cartVM.getMyProfile().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.cartVM.dismissIndicator()
            self.draftCompetitions = dataModel.data?.draftCompetitions ?? []

           }
       }, onError: { (error) in
        self.cartVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
}
