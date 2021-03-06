//
//  CreatPasswordVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit
import RxSwift
import RxCocoa


class CreatPasswordVc: UIViewController {

    @IBOutlet weak var iconImage : UIImageView!
    @IBOutlet weak var passwordTF : CustomTextField!
    @IBOutlet weak var mainTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var disposeBag = DisposeBag()
    private let AuthViewModel = AuthenticationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        mainTitleLbl.text = "CREATE.PASSWORD".localized
        titleLbl.text = "Your.Password".localized
        nextBtn.setTitle( "Next".localized, for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreatPasswordVc.dismissKeyboard))
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
    
    func validateInput() -> Bool {
        let password =  self.passwordTF.text ?? ""
        if password.isEmpty {
            displayMessage(title: "",message: "Enter.Password".localized, status: .error, forController: self)
          return false
        }else{
            return true
        }
    }

    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else { return }
        self.AuthViewModel.showIndicator()
        forgetPassword(password: passwordTF.text ?? "")
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

extension CreatPasswordVc {
    func forgetPassword(password : String) {
        AuthViewModel.checkPassword(password: password).subscribe(onNext: { (dataModel) in
            self.AuthViewModel.dismissIndicator()
            if dataModel.success ?? false {
                Helper.savePAssword(pass: self.passwordTF.text ?? "")
                let main = NameVc.instantiateFromNib()
                self.navigationController?.pushViewController(main!, animated: true)
            }else{
                displayMessage(title: "",message: "Password.Hint".localized, status: .error, forController: self)
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}
