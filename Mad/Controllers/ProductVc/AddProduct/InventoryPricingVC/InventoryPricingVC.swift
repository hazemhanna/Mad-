//
//  InventoryPricingVC.swift
//  Mad
//
//  Created by MAC on 28/04/2021.
//

import UIKit
import DLRadioButton

class InventoryPricingVC: UIViewController {

    @IBOutlet weak var limitedRadioButton: DLRadioButton!
    @IBOutlet weak var unlimitedRadioButton: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        limitedRadioButton.isSelected = true
    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func selectTypeAction(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            print("5")
        } else if sender.tag == 2 {
            print("4")
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton(sender: UIButton) {
        let vc = InventoryPricingVC.instantiateFromNib()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    


}
