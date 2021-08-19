//
//  CreatPasswordVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit

class CreatPasswordVc: UIViewController {

    @IBOutlet weak var iconImage : UIImageView!
    @IBOutlet weak var passwordTF : CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func validateInput() -> Bool {
        let password =  self.passwordTF.text ?? ""
        if password.isEmpty {
          self.showMessage(text: "Please Enter Your Password")
          return false
        }else if password.isPasswordValid() != true {
            self.showMessage(text: "Your Password Not Valid")
            return false
          }else{
            return true
        }
    }

    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else { return }
        Helper.savePAssword(pass: passwordTF.text ?? "")
        let main = NameVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }

    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreatPasswordVc :UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwordTF.text?.isPasswordValid() == true {
            iconImage.isHidden = false
        }else{
            iconImage.isHidden = true
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
}
