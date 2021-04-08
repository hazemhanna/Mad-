//
//  VerificationVc.swift
//  Mad
//
//  Created by MAC on 07/04/2021.
//

import UIKit

class VerificationVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func nextButton(sender: UIButton) {
            let main = CreatPasswordVc.instantiateFromNib()
            self.navigationController?.pushViewController(main!, animated: true)
    }
}
