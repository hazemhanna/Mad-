//
//  CurrencyViewController.swift
//  Mad
//
//  Created by MAC on 14/05/2022.
//



import UIKit
import RxSwift
import RxCocoa

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var selectCateDropDown: TextFieldDropDown!
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()

    var cats = ["USD" , "EU"]
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCatDropDown()
    }

    func setupCatDropDown(){
        selectCateDropDown.optionArray = self.cats
        selectCateDropDown.didSelect { (selectedText, index, id) in
            self.selectCateDropDown.text = selectedText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    

    
    @IBAction func nextButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CurrencyViewController {

}
