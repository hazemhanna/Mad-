//
//  Tutorial1.swift
//  Mad
//
//  Created by MAC on 30/03/2021.
//

import UIKit

class Tutorial1: UIViewController {
    
    @IBOutlet weak var firstView : CustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstView.clipsToBounds = true
        firstView.layer.cornerRadius = 3
        firstView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
    @IBAction func nextButton(sender: UIButton) {
        
        let main = Tutorial2.instantiateFromNib()
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = main
        }
        
    }
    
}
