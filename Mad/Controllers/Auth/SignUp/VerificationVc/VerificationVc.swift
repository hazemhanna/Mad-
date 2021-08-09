//
//  VerificationVc.swift
//  Mad
//
//  Created by MAC on 07/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class VerificationVc: UIViewController {
    
    @IBOutlet weak var codeTF: UITextField!
    
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var email = Helper.getUserEmail()
    
    var reset = false
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTF.delegate = self
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
    
    func validateInput() -> Bool {
        let code =  self.codeTF.text ?? ""
        if code.isEmpty {
          self.showMessage(text: "Please Enter Your Code First")
          return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else { return }
        Helper.saveCode(code : codeTF.text ?? "")
        if reset {
            let main = ResetPasswordVC.instantiateFromNib()
            self.navigationController?.pushViewController(main!, animated: true)
        }else {
            self.AuthViewModel.showIndicator()
            verfiyAccount()
        }
    }
}

extension VerificationVc {
     func verfiyAccount() {
        AuthViewModel.attemptToVerify(bindedEmail: email ?? "",bindedCode : codeTF.text ?? "").subscribe(onNext: { (registerData) in
            if registerData.success ?? false {
                self.AuthViewModel.dismissIndicator()
                let main = CreatPasswordVc.instantiateFromNib()
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

extension VerificationVc :UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
    
}
