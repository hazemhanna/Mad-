//
//  Tutorial3.swift
//  Mad
//
//  Created by MAC on 30/03/2021.
//

import UIKit

class Tutorial3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func nextButton(sender: UIButton) {
        
        let main = Tutorial4.instantiateFromNib()
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = main
        }
        
    }


}
