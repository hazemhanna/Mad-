//
//  EditUSerProfileVc.swift
//  Mad
//
//  Created by MAC on 12/10/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class EditUSerProfileVc: UIViewController {
    
   
    @IBOutlet weak var  firstNameTF : UITextField!
    @IBOutlet weak var  lastNameTF : UITextField!
    @IBOutlet weak var  emailTf : UITextField!
    @IBOutlet weak var  phoneTf : UITextField!
    @IBOutlet weak var  levelLbL : UILabel!
  
    
    var active = Helper.getIsActive() ?? false
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()


    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTf.delegate = self
        emailTf.delegate = self
        lastNameTF.delegate = self
        firstNameTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.artistVM.showIndicator()
        getProfile()
        
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func validateInput() -> Bool {
        let email =  self.emailTf.text ?? ""
        let phone =  self.phoneTf.text ?? ""
        let firstName =  self.firstNameTF.text ?? ""
        let lastName =  self.lastNameTF.text ?? ""
        
        if email.isEmpty {
              self.showMessage(text: "Please Enter Your email")
              return false
            }else if phone.isEmpty {
                self.showMessage(text: "Please Enter Your phone")
                return false
              }else if firstName.isEmpty {
                self.showMessage(text: "Please Enter Your first Name")
                return false
              }else if lastName.isEmpty {
                self.showMessage(text: "Please Enter Your last Name")
                return false
              }else{
                return true
             }
        
    }
    
    
    @IBAction func saveButton(sender: UIButton) {
        guard self.validateInput() else { return }
        self.artistVM.showIndicator()
        self.updateProfile(email: self.emailTf.text ?? "", phone: self.phoneTf.text ?? "", firstName: self.firstNameTF.text ?? "", lastName: self.lastNameTF.text ?? "")
    }
    
    @IBAction func ResetTapAction(sender: UIButton) {
        let main = EmailVc.instantiateFromNib()
        main?.reset = true
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func editAction(sender: UIButton) {
        if sender.tag == 0 {
            firstNameTF.becomeFirstResponder()
        }else if sender.tag == 1 {
            lastNameTF.becomeFirstResponder()

        }else if sender.tag == 2 {
            emailTf.becomeFirstResponder()

        }else if sender.tag == 3 {
            phoneTf.becomeFirstResponder()

        }
    }
}




extension EditUSerProfileVc {
func getProfile() {
    artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.artistVM.dismissIndicator()
        self.firstNameTF.text = dataModel.data?.firstName ??  ""
        self.lastNameTF.text = dataModel.data?.lastName ?? ""
        self.emailTf.text = dataModel.data?.userEmail ?? ""
        self.phoneTf.text = dataModel.data?.phone ?? ""
     }
   }, onError: { (error) in
    self.artistVM.dismissIndicator()

   }).disposed(by: disposeBag)
}
    
func updateProfile(email : String,phone : String,firstName : String,lastName : String) {
        artistVM.updateProfile(email: email, phone: phone, firstName: firstName, lastName: lastName).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.firstNameTF.text = dataModel.data?.firstName ??  ""
            self.lastNameTF.text = dataModel.data?.lastName ?? ""
            self.emailTf.text = dataModel.data?.userEmail ?? ""
            self.phoneTf.text = dataModel.data?.phone ?? ""
            self.showMessage(text: dataModel.message ?? "")
            self.navigationController?.popViewController(animated: true)

         }else{
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()
       }).disposed(by: disposeBag)
    }
    

}

extension EditUSerProfileVc: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
