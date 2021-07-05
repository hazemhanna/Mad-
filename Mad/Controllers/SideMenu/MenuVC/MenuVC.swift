//
//  MenuVC.swift
//  Mad
//
//  Created by MAC on 04/07/2021.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var artistView: UIView!
    @IBOutlet weak var titleLble: UILabel!

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
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
}
