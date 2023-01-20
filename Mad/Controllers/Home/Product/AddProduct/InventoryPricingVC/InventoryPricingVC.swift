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
import PTCardTabBar

class InventoryPricingVC: UIViewController {

    @IBOutlet weak var limitedRadioButton: DLRadioButton!
    @IBOutlet weak var unlimitedRadioButton: DLRadioButton!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var price_eur: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var delivery: UITextField!
    @IBOutlet weak var deliveryIndex: TextFieldDropDown!
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    var titles = ["days", "weeks"]
    var  short_description = String()
    var  descriptionTV = String()
    var  titleTV = String()
    var  materials = String()
    var  length = String()
    var  width = String()
    var  height = String()
    var  weight = String()
    var type = String()
    var quantitylimitation = "limited"
    var limited = true

    var selectedCat = [Int]()
    var uploadedPhoto = [UIImage]()
    var images = [UIImage]()

    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    
    var isFromEdit = false
    var product : ProductDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        limitedRadioButton.isSelected = true
        setupDeliveryIndexDropDown()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFromEdit{
            price.isUserInteractionEnabled = false
            price_eur.isUserInteractionEnabled = false
            price.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9176470588, blue: 0.937254902, alpha: 1)
            price_eur.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9176470588, blue: 0.937254902, alpha: 1)
            price.text = "\(product?.price ?? 0)"
            price_eur.text = "\(product?.priceEur ?? 0)"
            quantity.text = "\(product?.avaialble_quantity ?? 0 )"
            delivery.text = "\(product?.delivery ?? 0)"
            deliveryIndex.text = product?.deliveryIndex
        }
    }
    
    func setupDeliveryIndexDropDown() {
        deliveryIndex.optionArray = self.titles
        deliveryIndex.didSelect { (selectedText, index, id) in
            self.deliveryIndex.text = selectedText
        }
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
        }
    }
    
    @IBAction func selectTypeAction(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            self.quantitylimitation = "limited"
            limited = true
        } else if sender.tag == 2 {
            self.quantitylimitation = "unlimited"
            limited = false
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        let price =  self.price.text ?? ""
        let price_eur = self.price_eur.text ?? ""
        let quantity = self.quantity.text ?? ""
        let delivery = self.delivery.text ?? ""
        let deliveryIndex = self.deliveryIndex.text ?? ""
        if price.isEmpty {
          self.showMessage(text: "Please Enter  Price")
          return false
        }else if price_eur.isEmpty {
            self.showMessage(text: "Please Enter eur Price")
            self.productVM.dismissIndicator()
            return false
        } else if delivery.isEmpty {
            self.showMessage(text: "Please delivery price")
            self.productVM.dismissIndicator()
            return false
        }else if deliveryIndex.isEmpty {
            self.showMessage(text: "Please Enter delivery time")
            self.productVM.dismissIndicator()
            return false
        }else if limited{
            if quantity.isEmpty {
                self.showMessage(text: "Please Enter quantity")
                self.productVM.dismissIndicator()
                return false
            }else{
                return true
            }
        }else{
            return true
        }

    }
    @IBAction func nextButton(sender: UIButton) {
        view.endEditing(true)
        guard self.validateInput() else { return }
        self.productVM.showIndicator()
        if isFromEdit {
            self.editProduct(id: product?.id ?? 0,categories: self.selectedCat, title: self.title ?? self.titleTV, short_description: self.short_description, description: self.descriptionTV, materials: self.materials, length: Int(self.length) ?? 0, width: Int(self.width) ?? 0, height: Int(self.height) ?? 0, weight: Int(self.weight) ?? 0, type: self.type, price: Int(self.price.text ?? "") ?? 0, price_eur: Int(self.price_eur.text ?? "") ?? 0, quantity: Int(self.quantity.text ?? "") ?? 0, quantity_limitation: self.quantitylimitation , delivery: Int(self.delivery.text ?? "") ?? 0, delivery_index: self.deliveryIndex.text ?? "" , photos: self.images)
        }else{
            self.AddProduct(categories: self.selectedCat, title: self.title ?? self.titleTV, short_description: self.short_description, description: self.descriptionTV, materials: self.materials, length: Int(self.length) ?? 0, width: Int(self.width) ?? 0, height: Int(self.height) ?? 0, weight: Int(self.weight) ?? 0, type: self.type, price: Int(self.price.text ?? "") ?? 0, price_eur: Int(self.price_eur.text ?? "") ?? 0, quantity: Int(self.quantity.text ?? "") ?? 0, quantity_limitation: self.quantitylimitation , delivery: Int(self.delivery.text ?? "") ?? 0, delivery_index: self.deliveryIndex.text ?? "" , photos: self.uploadedPhoto)
        }
    }
}

extension InventoryPricingVC {
     func AddProduct(categories :[Int],title :String,short_description:String,description:String,materials: String,length: Int,width: Int,height: Int,weight: Int,type: String,price:Int,price_eur:Int,quantity:Int,quantity_limitation:String,delivery:Int,delivery_index:String,photos:[UIImage]) {
        productVM.CreatProduct(categories: categories, title: title, short_description: short_description, description: description, materials: materials, length: length, width: width, height: height, weight: weight, type: type, price: price, price_eur: price_eur, quantity: quantity, quantity_limitation: quantity_limitation, delivery: delivery, delivery_index: delivery_index, photos: photos).subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
                self.productVM.dismissIndicator()
                self.showMessage(text: dataModel.message ?? "")
                let story = UIStoryboard(name: "Main", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "CardTabBarController")
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }else{
                self.productVM.dismissIndicator()
                self.showMessage(text: dataModel.message ?? "")
            }
        }, onError: { (error) in
            self.productVM.dismissIndicator()

        }).disposed(by: disposeBag)
    }
    
    func editProduct(id:Int,
                     categories :[Int],
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
        productVM.editProduct(id: id,categories: categories, title: title, short_description: short_description, description: description, materials: materials, length: length, width: width, height: height, weight: weight, type: type, price: price, price_eur: price_eur, quantity: quantity, quantity_limitation: quantity_limitation, delivery: delivery, delivery_index: delivery_index, photos: photos).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
               self.productVM.dismissIndicator()
               self.showMessage(text: dataModel.message ?? "")
               let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
               self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
           }else{
               self.productVM.dismissIndicator()
               self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
           self.productVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}


