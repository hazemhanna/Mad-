//
//  AddressVC.swift
//  Mad
//
//  Created by MAC on 05/07/2021.
//

import UIKit



import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class AddressVC: UIViewController {
    
    @IBOutlet weak var firstNameTF: CustomTextField!
    @IBOutlet weak var lastNameTF: CustomTextField!
    @IBOutlet weak var phoneNumberTF: CustomTextField!
    @IBOutlet weak var CompanyameTF: CustomTextField!
    @IBOutlet weak var emailTf: CustomTextField!
    @IBOutlet weak var countryTF: CustomTextField!
    @IBOutlet weak var streetTF: CustomTextField!
    @IBOutlet weak var cityTF: CustomTextField!
    @IBOutlet weak var stateTF: CustomTextField!
    @IBOutlet weak var postCodeTf: CustomTextField!
    @IBOutlet weak var noteTf: CustomTextField!

    var compId = Int()
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        phoneNumberTF.delegate = self
        CompanyameTF.delegate = self
        emailTf.delegate = self
        noteTf.delegate = self
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
        let artistName = self.CompanyameTF.text ?? ""
        let personal = self.noteTf.text ?? ""
        
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
            self.showMessage(text: "Please Enter Company Name")
            return false
        }else if personal.isEmpty {
            self.showMessage(text: "Please Enter note")
            return false
        }else{
            return true
        }
    }

    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else {return}
    }
    
}

extension AddressVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
