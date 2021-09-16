//
//  NameVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit

class NameVc: UIViewController {
    
    @IBOutlet weak var firstNameTF : CustomTextField!
    @IBOutlet weak var lastNameTF : CustomTextField!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTF.delegate = self
        lastNameTF.delegate = self

        firstNameLbl.text = "first.Name".localized
        lastNameLbl.text = "last.Name".localized
        titleLbl.text = "YOUR.NAME".localized
        nextBtn.setTitle( "Next".localized, for: .normal)
        
    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func validateInput() -> Bool {
        let firstName =  self.firstNameTF.text ?? ""
        let lasName =  self.lastNameTF.text ?? ""
        
        if firstName.isEmpty {
            displayMessage(title: "",message: "Enter.first.Name".localized, status: .error, forController: self)

          return false
        }else if lasName.isEmpty {
            displayMessage(title: "",message: "Enter.last.Name".localized, status: .error, forController: self)
          return false
        }else{
            return true
        }
        
    }
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else { return }
        Helper.saveFirstName(firstName: self.firstNameTF.text ?? "")
        Helper.saveLastName(LastName: self.lastNameTF.text ?? "")
        let main = AgeVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }

    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
}

extension NameVc :UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
}
