//
//  AddCompetitionsDetailsVc.swift
//  Mad
//
//  Created by MAC on 18/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class AddCompetitionsDetailsVc: UIViewController {
    
    @IBOutlet weak var firstNameTF: CustomTextField!
    @IBOutlet weak var lastNameTF: CustomTextField!
    @IBOutlet weak var phoneNumberTF: CustomTextField!
    @IBOutlet weak var artistNameTF: CustomTextField!
    @IBOutlet weak var emailTf: CustomTextField!
    @IBOutlet weak var personalTf: CustomTextField!

    
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
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        let firstName = self.firstNameTF.text ?? ""
        let lastName = self.lastNameTF.text ?? ""
        let phoneNumber = self.phoneNumberTF.text ?? ""
        let email = self.emailTf.text ?? ""
        let artistName = self.artistNameTF.text ?? ""
        let personal = self.personalTf.text ?? ""
        
        if firstName.isEmpty {
            self.showMessage(text: "Please Enter first Name")
            return false
        }else if lastName.isEmpty {
            self.showMessage(text: "Please Enter last Name")
            return false
        }else if phoneNumber.isEmpty {
            self.showMessage(text: "Please Enter phone Number")
            return false
        }else if email.isEmpty {
            self.showMessage(text: "Please Enter email")
            return false
        }else if artistName.isEmpty {
            self.showMessage(text: "Please Enter artist Name")
            return false
        }else if personal.isEmpty {
            self.showMessage(text: "Please Enter personal information")
            return false
        }else{
            return true
        }
    }

    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else {return}

        let vc = AddCompetitionsUploadFileVC.instantiateFromNib()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
