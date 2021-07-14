//
//  PaymentVC.swift
//  Mad
//
//  Created by MAC on 14/07/2021.
//


import UIKit
import RxSwift
import RxCocoa

class PaymentVC: UIViewController {

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
        let main = PaymentDetailsVC.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
}

extension PaymentVC{


}
