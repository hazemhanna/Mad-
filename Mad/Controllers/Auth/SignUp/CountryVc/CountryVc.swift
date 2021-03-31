//
//  CountryVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit

class CountryVc: UIViewController {
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButton(sender: UIButton) {
        let main = CategeoryVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }

    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
}
