//
//  NameVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit

class NameVc: UIViewController {
    @IBOutlet weak var nameTF : CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButton(sender: UIButton) {
        let main = AgeVc.instantiateFromNib()
       // main!.name = nameTF.text ?? "Rola"
        self.navigationController?.pushViewController(main!, animated: true)
    }

    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
}
