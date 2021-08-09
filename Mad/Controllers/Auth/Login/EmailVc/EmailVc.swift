//
//  EmailVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit
import RxSwift
import RxCocoa

class EmailVc: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var titleLbl : UILabel!

    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var register = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if register {
            titleLbl.text = "LOGIN"
        }else{
            titleLbl.text = "SIGNUP"
        }
        
    }
    
    func validateInput() -> Bool {
        let email =  self.emailTF.text ?? ""
        if email.isEmpty {
          self.showMessage(text: "Please Enter Your Email First")
          return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else { return }
        Helper.saveEmial(email: self.emailTF.text ?? "")
        if register {
            self.AuthViewModel.showIndicator()
            CreateAccount()
        }else{
            let main = PasswordVc.instantiateFromNib()
            self.navigationController?.pushViewController(main!, animated: true)
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
}

extension EmailVc {
     func CreateAccount() {
        AuthViewModel.attemptToRegister(bindedEmail: emailTF.text ?? "").subscribe(onNext: { (registerData) in
            if registerData.success ?? false {
                self.AuthViewModel.dismissIndicator()
                self.showMessage(text: registerData.message ?? "")
                let main = VerificationVc.instantiateFromNib()
                self.navigationController?.pushViewController(main!, animated: true)
            }else{
                self.AuthViewModel.dismissIndicator()
                self.showMessage(text: registerData.message ?? "")
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}

extension EmailVc:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
}
