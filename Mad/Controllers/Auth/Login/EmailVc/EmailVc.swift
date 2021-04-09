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

    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var register = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
        if register {
            guard self.validateInput() else { return }
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
            if registerData.success {
                self.AuthViewModel.dismissIndicator()
                let main = VerificationVc.instantiateFromNib()
                self.navigationController?.pushViewController(main!, animated: true)
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}
