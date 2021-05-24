//
//  CountryVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit
import RxSwift
import RxCocoa

class CountryVc: UIViewController {
    
    @IBOutlet weak var selectCateDropDown: TextFieldDropDown!
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()

    var cats = [String]()
    var countries = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.AuthViewModel.fetchCountries(Countries: self.countries)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AuthViewModel.showIndicator()
        getCountry()
    }

    func setupCatDropDown(){
        selectCateDropDown.optionArray = self.cats
        selectCateDropDown.didSelect { (selectedText, index, id) in
            self.selectCateDropDown.text = selectedText
            Helper.saveCountry(id: self.countries[index])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func validateInput() -> Bool {
        let age =  self.selectCateDropDown.text ?? ""
        if age.isEmpty {
          self.showMessage(text: "Please select Your Country")
          return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else { return }
        let main = CategeoryVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }

    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension CountryVc {
     func getCountry() {
        AuthViewModel.getAllCountries().subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
                self.AuthViewModel.dismissIndicator()
                self.countries = dataModel.data ?? []
                self.cats = dataModel.data ?? []
                self.setupCatDropDown()
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}
