//
//  Tutorial4.swift
//  Mad
//
//  Created by MAC on 30/03/2021.
//

import UIKit

class Tutorial4: UIViewController {

    @IBOutlet weak var lastView : CustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lastView.clipsToBounds = true
        lastView.layer.cornerRadius = 3
        lastView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
   
    @IBAction func nextButton(sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = sb
        }        
        
    }

}
