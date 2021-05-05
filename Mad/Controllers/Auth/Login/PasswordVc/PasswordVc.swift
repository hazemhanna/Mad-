//
//  PasswordVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordVc: UIViewController {
   
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var lineImage: UIImageView!
    @IBOutlet weak var resetLbl: UILabel!
    
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var email = Helper.getUserEmail()
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ResetTapAction(_:)))
        resetLbl.isUserInteractionEnabled = true
        resetLbl.addGestureRecognizer(gestureRecognizer)
        setupMultiColorRegisterLabel()
        
        passwordTF.delegate = self
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
    
    //MARK:- Register Label Action Configurations
    @objc func ResetTapAction(_ sender: UITapGestureRecognizer) {
       print("true")
    }
    
    func setupMultiColorRegisterLabel() {
        let main_string = "Forgot PASSWORD? Reset Now"
        let coloredString = "Reset Now"
        let Range = (main_string as NSString).range(of: coloredString)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1) , range: Range)
        resetLbl.attributedText = attribute
    }
    
    func validateInput() -> Bool {
        let email =  self.passwordTF.text ?? ""
        if email.isEmpty {
          self.showMessage(text: "Please Enter Your Password")
          return false
        }else{
            return true
        }
    }
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else { return }
        self.AuthViewModel.showIndicator()
        login()
    }
}

extension PasswordVc {
     func login() {
        AuthViewModel.attemptToLogin(bindedEmail: email ?? "" ,bindedPassword : passwordTF.text ?? "" ).subscribe(onNext: { (registerData) in
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

extension PasswordVc :UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
}
