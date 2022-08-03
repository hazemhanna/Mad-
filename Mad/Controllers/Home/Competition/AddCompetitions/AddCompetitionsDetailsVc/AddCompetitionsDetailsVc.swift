//
//  AddCompetitionsDetailsVc.swift
//  Mad
//
//  Created by MAC on 18/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class AddCompetitionsDetailsVc: UIViewController {
    
    @IBOutlet weak var firstNameTF: CustomTextField!
    @IBOutlet weak var lastNameTF: CustomTextField!
    @IBOutlet weak var phoneNumberTF: CustomTextField!
    @IBOutlet weak var artistNameTF: CustomTextField!
    @IBOutlet weak var emailTf: CustomTextField!
    @IBOutlet weak var personalTf: CustomTextField!
    var competitionVm = CometitionsViewModel()
    var disposeBag = DisposeBag()
    
    var compId = Int()
    var candidate:Candidate?

    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        phoneNumberTF.delegate = self
        artistNameTF.delegate = self
        emailTf.delegate = self
        personalTf.delegate = self
        self.competitionVm.showIndicator()
        getProfile()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
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
        let firstName = self.firstNameTF.text ?? ""
        let lastName = self.lastNameTF.text ?? ""
        let phoneNumber = self.phoneNumberTF.text ?? ""
        let email = self.emailTf.text ?? ""
        let artistName = self.artistNameTF.text ?? ""
        let personal = self.personalTf.text ?? ""
        
        if firstName.isEmpty {
            self.showMessage(text: "Please Enter first Name")
            return false
        }else if lastName.isEmpty {
            self.showMessage(text: "Please Enter last Name")
            return false
        }else if phoneNumber.isEmpty {
            self.showMessage(text: "Please Enter phone Number")
            return false
        }else if email.isEmpty {
            self.showMessage(text: "Please Enter email")
            return false
        }else if artistName.isEmpty {
            self.showMessage(text: "Please Enter artist Name")
            return false
        }else if personal.isEmpty {
            self.showMessage(text: "Please Enter personal information")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else {return}
        let vc = AddCompetitionsUploadFileVC.instantiateFromNib()
        vc!.firstName = self.firstNameTF.text ?? ""
        vc!.lastName = self.lastNameTF.text ?? ""
        vc!.phoneNumber = self.phoneNumberTF.text ?? ""
        vc!.email = self.emailTf.text ?? ""
        vc!.artistName = self.artistNameTF.text ?? ""
        vc!.personal = self.personalTf.text ?? ""
        vc!.compId = compId
        vc!.candidate = candidate
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension AddCompetitionsDetailsVc: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension AddCompetitionsDetailsVc {
  func getProfile() {
      competitionVm.getMyProfile().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.competitionVm.dismissIndicator()
        self.firstNameTF.text = dataModel.data?.firstName ??  ""
        self.lastNameTF.text = dataModel.data?.lastName ?? ""
        self.artistNameTF.text = dataModel.data?.name ?? ""
        self.emailTf.text = dataModel.data?.userEmail ?? ""
     }
   }, onError: { (error) in
    self.competitionVm.dismissIndicator()

   }).disposed(by: disposeBag)
      
  }
}
