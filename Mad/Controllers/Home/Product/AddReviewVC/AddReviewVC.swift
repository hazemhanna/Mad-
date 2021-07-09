//
//  AddReviewVC.swift
//  Mad
//
//  Created by MAC on 09/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar


class AddReviewVC: UIViewController {

    
    @IBOutlet weak var titleTf: CustomTextField!
    @IBOutlet weak var commentTf: CustomTextField!
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    

    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    @IBAction func submitButton(sender: UIButton) {


    }
    
    
}
