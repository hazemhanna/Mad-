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
    @IBOutlet weak var sigenLbl: UILabel!

    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var register = false
    var reset  = false
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ResetTapAction(_:)))
        sigenLbl.isUserInteractionEnabled = true
        sigenLbl.addGestureRecognizer(gestureRecognizer)
        setupMultiColorRegisterLabel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(EmailVc.dismissKeyboard))
         view.addGestureRecognizer(tap)
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if register {
            titleLbl.text = "SIGNUP".localized
            self.sigenLbl.isHidden = true
        }else if reset {
            titleLbl.text = "Forgot".localized
            self.sigenLbl.isHidden = false
        }else{
            titleLbl.text = "LOGIN".localized
            self.sigenLbl.isHidden = false
        }
    }
    
    //MARK:- Register Label Action Configurations
    @objc func ResetTapAction(_ sender: UITapGestureRecognizer) {
    if Helper.getType() ?? false{
        let main = WelcomVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
     }else{
            let main = EmailVc.instantiateFromNib()
             main?.register = true
             self.navigationController?.pushViewController(main!, animated: true)
        }
    }
    
    func setupMultiColorRegisterLabel() {
        let main_string = "Don't".localized
        let coloredString = "Sign.up".localized
        let Range = (main_string as NSString).range(of: coloredString)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) , range: Range)
        sigenLbl.attributedText = attribute
    }
    
    func validateInput() -> Bool {
        let email =  self.emailTF.text ?? ""
        if email.isEmpty {
            displayMessage(title: "", message: "Enter.email".localized, status: .error, forController: self)
          return false
        } else if email.isValidEmail() != true{
            displayMessage(title: "", message: "valid.email".localized, status: .error, forController: self)
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
        }else if reset {
            self.AuthViewModel.showIndicator()
            forgetPassword()
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
                displayMessage(title: "", message: registerData.message ?? "", status: .success, forController: self)

                let main = VerificationVc.instantiateFromNib()
                self.navigationController?.pushViewController(main!, animated: true)
            }else{
                self.AuthViewModel.dismissIndicator()
                displayMessage(title: "", message: registerData.message ?? "", status: .error, forController: self)
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()

        }).disposed(by: disposeBag)
    }
    
    
    func forgetPassword() {
       AuthViewModel.forgetPassword().subscribe(onNext: { (registerData) in
           if registerData.success ?? false {
            self.AuthViewModel.dismissIndicator()
            displayMessage(title: "", message: registerData.message ?? "", status: .success, forController: self)
            let main = VerificationVc.instantiateFromNib()
            main?.reset = true
            self.navigationController?.pushViewController(main!, animated: true)
           }else{
               self.AuthViewModel.dismissIndicator()
            displayMessage(title: "", message: registerData.message ?? "", status: .error, forController: self)
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
