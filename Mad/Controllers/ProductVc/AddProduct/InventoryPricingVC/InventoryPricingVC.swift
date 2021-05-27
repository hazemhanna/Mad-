//
//  InventoryPricingVC.swift
//  Mad
//
//  Created by MAC on 28/04/2021.
//

import UIKit
import DLRadioButton
import RxSwift
import RxCocoa

class InventoryPricingVC: UIViewController {

    @IBOutlet weak var limitedRadioButton: DLRadioButton!
    @IBOutlet weak var unlimitedRadioButton: DLRadioButton!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var price_eur: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var delivery: UITextField!
    @IBOutlet weak var deliveryIndex: TextFieldDropDown!
    
   var  short_description = String()
    var  descriptionTV = String()
    var  titleTV = String()
    var  materials = String()
    var  length = String()
    var  width = String()
    var  height = String()
    var  weight = String()
    var type = String()
    
 var quantitylimitation = String()

    var selectedCat = [Category]()
    var uploadedPhoto = [UIImage]()
    
    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        limitedRadioButton.isSelected = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        view.endEditing(true)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func selectTypeAction(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            self.quantitylimitation = "limited"
        } else if sender.tag == 2 {
            self.quantitylimitation = "Unlimited"
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextButton(sender: UIButton) {
        
        self.AddProduct(categories: self.selectedCat, title: self.title ?? self.titleTV, short_description: self.short_description, description: self.descriptionTV, materials: self.materials, length: Int(self.length) ?? 0, width: Int(self.width) ?? 0, height: Int(self.height) ?? 0, weight: Int(self.weight) ?? 0, type: self.type, price: Int(self.price.text ?? "") ?? 0, price_eur: Int(self.price_eur.text ?? "") ?? 0, quantity: Int(self.quantity.text ?? "") ?? 0, quantity_limitation: self.quantitylimitation , delivery: Int(self.delivery.text ?? "") ?? 0, delivery_index: self.deliveryIndex.text ?? "" , photos: self.uploadedPhoto)
    
    }
    
}

extension InventoryPricingVC {
     func AddProduct(categories :[Category],
                     title :String,
                     short_description:String,
                     description:String,
                     materials: String,
                     length: Int,
                     width: Int,
                     height: Int,
                     weight: Int,
                     type: String,
                     price:Int,
                     price_eur:Int,
                     quantity:Int,
                     quantity_limitation:String,
                     delivery:Int,
                     delivery_index:String,
                     photos:[UIImage]) {
        productVM.CreatProduct(categories: categories, title: title, short_description: short_description, description: description, materials: materials, length: length, width: width, height: height, weight: weight, type: type, price: price, price_eur: price_eur, quantity: quantity, quantity_limitation: quantity_limitation, delivery: delivery, delivery_index: delivery_index, photos: photos).subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
                self.productVM.dismissIndicator()
            }
        }, onError: { (error) in
            self.productVM.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}


