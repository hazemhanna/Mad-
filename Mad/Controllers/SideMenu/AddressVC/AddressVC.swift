//
//  AddressVC.swift
//  Mad
//
//  Created by MAC on 05/07/2021.
//

import UIKit



import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class AddressVC: UIViewController {
    
    @IBOutlet weak var firstNameTF: CustomTextField!
    @IBOutlet weak var lastNameTF: CustomTextField!
    @IBOutlet weak var phoneNumberTF: CustomTextField!
    @IBOutlet weak var CompanyameTF: CustomTextField!
    @IBOutlet weak var emailTf: CustomTextField!
    @IBOutlet weak var countryTF: TextFieldDropDown!
    @IBOutlet weak var streetTF: CustomTextField!
    @IBOutlet weak var cityTF: CustomTextField!
    @IBOutlet weak var stateTF: CustomTextField!
    @IBOutlet weak var postCodeTf: CustomTextField!
    @IBOutlet weak var noteTf: CustomTextField!

    @IBOutlet weak var titleLbL: UILabel!
    @IBOutlet weak var contactTitleLbL: UILabel!
    @IBOutlet weak var addressTitleLbL: UILabel!
    @IBOutlet weak var firstNameLbL: UILabel!
    @IBOutlet weak var lastNameLbL: UILabel!
    @IBOutlet weak var phoneNumberLbL: UILabel!
    @IBOutlet weak var CompanyameLbL: UILabel!
    @IBOutlet weak var emailLbL: UILabel!
    @IBOutlet weak var countryLbL: UILabel!
    @IBOutlet weak var streetLbL: UILabel!
    @IBOutlet weak var cityLbL: UILabel!
    @IBOutlet weak var stateLbL: UILabel!
    @IBOutlet weak var postCodeLbL: UILabel!
    @IBOutlet weak var noteLbL: UILabel!
    @IBOutlet weak var savBtn: UIButton!

    var compId = Int()
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    var countries = [String]()
    
    var disposeBag = DisposeBag()
    var cartVM = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        phoneNumberTF.delegate = self
        CompanyameTF.delegate = self
        emailTf.delegate = self
        noteTf.delegate = self        
        countryTF.delegate = self
        cityTF.delegate = self
        streetTF.delegate = self
        stateTF.delegate = self
        postCodeTf.delegate = self
        
        titleLbL.text = "Contact.Address.details".localized
        contactTitleLbL.text = "Contact.details".localized
        addressTitleLbL.text = "Address.details".localized
        firstNameLbL.text = "first.Name".localized
        lastNameLbL.text = "last.Name".localized
        phoneNumberLbL.text = "Phone".localized
        CompanyameLbL.text = "Company".localized
        emailLbL.text = "Email.Address".localized
        countryLbL.text = "Country".localized
        streetLbL.text = "Street".localized
        cityLbL.text = "Town".localized
        stateLbL.text = "State".localized
        postCodeLbL.text = "Postcode".localized
        noteLbL.text = "Other.notes".localized
        savBtn.setTitle( "Save".localized, for: .normal)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
        self.cartVM.showIndicator()
        getCountry()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupCatDropDown(){
        countryTF.optionArray = self.countries
        countryTF.didSelect { (selectedText, index, id) in
            self.countryTF.text = selectedText
            Helper.saveCountry(id: self.countries[index])
        }
    }
    
    func validateInput() -> Bool {
        let firstName = self.firstNameTF.text ?? ""
        let lastName = self.lastNameTF.text ?? ""
        let phoneNumber = self.phoneNumberTF.text ?? ""
        let email = self.emailTf.text ?? ""
        let country = self.countryTF.text ?? ""
        let street = self.streetTF.text ?? ""
        let city = self.cityTF.text ?? ""
        let state = self.stateTF.text ?? ""
        let postcode = self.postCodeTf.text ?? ""
        
        if firstName.isEmpty {
            self.showMessage(text: "Enter.first.Name".localized)
            return false
        }else if lastName.isEmpty {
            self.showMessage(text: "Enter.last.Name".localized)
            return false
        }else if phoneNumber.isEmpty {
            self.showMessage(text: "Enter.phone".localized)
            return false
        }else if email.isEmpty {
            self.showMessage(text: "Enter.email".localized)
            return false
        }else if country.isEmpty {
            self.showMessage(text: "Enter.country".localized)
            return false
        }else if street.isEmpty {
            self.showMessage(text: "Enter.street".localized)
            return false
        }else if city.isEmpty {
            self.showMessage(text: "Enter.city".localized)
            return false
        }else if state.isEmpty {
            self.showMessage(text: "Enter.state".localized)
            return false
        }else if postcode.isEmpty {
            self.showMessage(text: "Enter.postcode".localized)
            return false
        }else{
            return true
        }
    }

    @IBAction func saveButton(sender: UIButton) {
        guard self.validateInput() else {return}
        let firstName = self.firstNameTF.text ?? ""
        let lastName = self.lastNameTF.text ?? ""
        let phoneNumber = self.phoneNumberTF.text ?? ""
        let email = self.emailTf.text ?? ""
        let country = self.countryTF.text ?? ""
        let street = self.streetTF.text ?? ""
        let city = self.cityTF.text ?? ""
        let state = self.stateTF.text ?? ""
        let postcode = self.postCodeTf.text ?? ""
        let company = self.CompanyameTF.text ?? ""
        let note = self.noteTf.text ?? ""

        self.cartVM.showIndicator()
        self.updateCartDetails(fName: firstName, lName: lastName, phone: phoneNumber, email: email, country: country, company_name: company, street_address: street, city: city, state: state, postcode: postcode, other_note: note)
        
    }
    
}

extension AddressVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension AddressVC {

func updateCartDetails(fName :String,
                  lName :String,
                  phone:String,
                  email:String,
                  country:String,
                  company_name:String,
                  street_address:String,
                  city:String,
                  state:String,
                  postcode:String,
                  other_note:String ){
    cartVM.updateCartDetails(fName: fName, lName: lName, phone: phone, email: email, country: country, company_name: company_name, street_address: street_address, city: city, state: state, postcode: postcode, other_note: other_note).subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.cartVM.dismissIndicator()
        self.showMessage(text: dataModel.message ?? "")
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
       }else{
        self.cartVM.dismissIndicator()
        self.showMessage(text: dataModel.message ?? "")
       }
   }, onError: { (error) in
    self.cartVM.dismissIndicator()
   }).disposed(by: disposeBag)
  }
    
    func getCountry() {
        cartVM.getAllCountries().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
               self.cartVM.dismissIndicator()
               self.countries = dataModel.data ?? []
               self.setupCatDropDown()
           }
       }, onError: { (error) in
           self.cartVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
}
