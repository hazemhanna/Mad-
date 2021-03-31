//
//  AgeVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit

class AgeVc: UIViewController {

    @IBOutlet weak var nameLbl : UILabel!
    
    var name :String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nameLbl.text = "HI \(name ?? "")!"

    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButton(sender: UIButton) {
        let main = CountryVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }

    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
}
