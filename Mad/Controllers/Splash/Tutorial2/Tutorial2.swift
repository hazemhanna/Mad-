//
//  Tutorial2.swift
//  Mad
//
//  Created by MAC on 30/03/2021.
//

import UIKit

class Tutorial2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func nextButton(sender: UIButton) {
        
        let main = Tutorial3.instantiateFromNib()
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = main
        }
        
    }

    
}
