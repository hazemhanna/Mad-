//
//  SubmitCopetitionsVC.swift
//  Mad
//
//  Created by MAC on 18/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class SubmitCopetitionsVC: UIViewController {

    @IBOutlet weak var presentTf: CustomTextField!
    @IBOutlet weak var socialTF: TextFieldDropDown!
    
    var social = [String]()

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
    
    func setupsocialDropDown(){
        socialTF.optionArray = self.social
        socialTF.didSelect { (selectedText, index, id) in
            self.socialTF.text = selectedText
        }
    }
    
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        let present = self.presentTf.text ?? ""
        let social = self.socialTF.text ?? ""
        if present.isEmpty {
            self.showMessage(text: "Please What do you want to present")
            return false
        }else if social.isEmpty {
            self.showMessage(text: "Please Enter where you konw about us")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func saveButton(sender: UIButton) {
        guard self.validateInput() else {return}

    }

    @IBAction func submitButton(sender: UIButton) {
        guard self.validateInput() else {return}

    }
    
}
