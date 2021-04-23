//
//  CompetitionsVc.swift
//  Mad
//
//  Created by MAC on 23/04/2021.
//

import UIKit

class CompetitionsVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }


}
