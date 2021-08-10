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

    
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var email = Helper.getUserEmail()
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        confirmTF.delegate = self
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
          self.showMessage(text: "Please Enter Your Password")
          return false
        }else if confirmPassword.isEmpty {
            self.showMessage(text: "Please Enter Your Password")
            return false
        }else if confirmPassword != password {
            self.showMessage(text: "password not match")
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
                let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardTabBarController")
                if let appDelegate = UIApplication.shared.delegate {
                    appDelegate.window??.rootViewController = sb
                }
            }else{
                self.showMessage(text: registerData.message ?? "")
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
