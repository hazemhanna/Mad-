//
//  ResetPasswordVC.swift
//  Mad
//
//  Created by MAC on 09/08/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ResetPasswordVC: UIViewController {
   
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var confirmTF: CustomTextField!
    @IBOutlet weak var lineImage: UIImageView!
    @IBOutlet weak var lineImage2: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ResetBtn: UIButton!
    
    
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var email = Helper.getUserEmail()
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        confirmTF.delegate = self
        
        titleLbl.text = "Reset.password".localized
        passwordTF.placeholder = "New.password".localized
        confirmTF.placeholder = "confirm.password".localized
        ResetBtn.setTitle("Reset".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var showOld  = false
    @IBAction func showOldActions(_ sender: UIButton) {
              if showOld ==  false  {
                  self.passwordTF.isSecureTextEntry = false
                  lineImage.isHidden = true
                  showOld = true
              }else{
                self.passwordTF.isSecureTextEntry = true
                lineImage.isHidden = false
                showOld = false
              }
      }
    
    
    
    var showOld2  = false
    @IBAction func showOld2Actions(_ sender: UIButton) {
              if showOld2 ==  false  {
                  self.confirmTF.isSecureTextEntry = false
                  lineImage2.isHidden = true
                  showOld2 = true
              }else{
                self.confirmTF.isSecureTextEntry = true
                lineImage2.isHidden = false
                showOld2 = false
              }
      }
    
    func validateInput() -> Bool {
        let password =  self.passwordTF.text ?? ""
        let confirmPassword =  self.confirmTF.text ?? ""

        if password.isEmpty {
            displayMessage(title: "",message: "Enter.Password".localized, status: .error, forController: self)

          return false
        }else if password.isPasswordValid() != true {
            displayMessage(title: "",message: "Password.Hint".localized, status: .error, forController: self)

            return false
        }else if confirmPassword.isEmpty {
            displayMessage(title: "",message: "Enter.Password".localized, status: .error, forController: self)

            return false
        }else if confirmPassword != password {
            displayMessage(title: "",message: "not.match".localized, status: .error, forController: self)
            return false
          }else{
            return true
        }
    }
    @IBAction func nextButton(sender: UIButton) {
        Helper.savePAssword(pass: passwordTF.text ?? "")
        guard self.validateInput() else { return }
        self.AuthViewModel.showIndicator()
        reset()
    }
    
}

extension ResetPasswordVC {
     func reset() {
        AuthViewModel.resetPassword().subscribe(onNext: { (registerData) in
            self.AuthViewModel.dismissIndicator()
            if registerData.success ?? false {
                let main = EmailVc.instantiateFromNib()
                self.navigationController?.pushViewController(main!, animated: true)
            }else{
                displayMessage(title: "",message: registerData.message ?? "", status: .error, forController: self)
            }

        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}

extension ResetPasswordVC :UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
}
