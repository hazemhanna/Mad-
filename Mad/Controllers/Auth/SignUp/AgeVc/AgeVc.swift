//
//  AgeVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit

class AgeVc: UIViewController {

    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var ageTF : CustomTextField!

    var name  = (Helper.getUserFirstName() ?? "") + " " + (Helper.getUserLastName() ?? "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = "HI \(name)"
        ageTF.delegate = self
    
    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func validateInput() -> Bool {
        let age =  self.ageTF.text ?? ""
        if age.isEmpty {
          self.showMessage(text: "Please Enter Your age")
          return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else { return }
        Helper.saveAge(Age: self.ageTF.text ?? "")
        let main = CountryVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
}


extension AgeVc :UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
}
