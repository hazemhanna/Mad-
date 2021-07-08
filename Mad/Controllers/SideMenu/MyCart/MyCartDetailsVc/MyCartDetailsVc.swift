//
//  MyCartDetailsVc.swift
//  Mad
//
//  Created by MAC on 04/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class MyCartDetailsVc: UIViewController {

    @IBOutlet weak var phoneNumberlbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var countrylbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var citylbl: UILabel!

    
    var disposeBag = DisposeBag()
    var cartVM = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func viewWillAppear(_ animated: Bool) {
        cartVM.showIndicator()
        getCartDetails()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func editAddressAction(sender: UIButton) {
        let main = AddressVC.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
}

extension MyCartDetailsVc{
func getCartDetails() {
    cartVM.getCartDetials().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.cartVM.dismissIndicator()
        self.countrylbl.text  = dataModel.data?.country ?? ""
        self.citylbl.text  = dataModel.data?.city ?? ""
        self.addressLbl.text  = dataModel.data?.address ?? ""
        self.emaillbl.text  = dataModel.data?.email ?? ""
        self.phoneNumberlbl.text  = dataModel.data?.phone ?? ""
       }
   }, onError: { (error) in
    self.cartVM.dismissIndicator()
   }).disposed(by: disposeBag)
  }
}
