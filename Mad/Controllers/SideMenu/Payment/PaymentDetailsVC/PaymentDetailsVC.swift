//
//  PaymentDetailsVC.swift
//  Mad
//
//  Created by MAC on 14/07/2021.
//



import UIKit
import RxSwift
import RxCocoa

class PaymentDetailsVC : UIViewController {

    @IBOutlet weak var saveBtn : UIButton!
  

    var save = true

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
    
    @IBAction func saveAction(sender: UIButton) {
      
    }
    
    
    @IBAction func saveDataAction(sender: UIButton) {
        if self.save == true {
            self.saveBtn.setImage(nil, for: .normal)
            save = false
        } else {
            self.saveBtn.setImage(#imageLiteral(resourceName: "icon - check (1)"), for: .normal)
            save = true
        }
    }
    
    
}

extension PaymentDetailsVC{

}
