//
//  BlogsVc.swift
//  Mad
//
//  Created by MAC on 21/04/2021.
//

import UIKit

class BlogsVc: UIViewController {

    var parentVC : HomeVC?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
