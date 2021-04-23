//
//  ArtistProfileVc.swift
//  Mad
//
//  Created by MAC on 20/04/2021.
//

import Foundation
import UIKit

class ArtistProfileVc: UIViewController {
    
    @IBOutlet weak var containerView: UIView!

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
    
    
}

extension ArtistProfileVc  {
   
}

extension ArtistProfileVc {

}
