//
//  ListingDetailsVC.swift
//  Mad
//
//  Created by MAC on 28/04/2021.
//

import UIKit
import DLRadioButton
import WSTagsField
import RxSwift
import RxCocoa
import PTCardTabBar

class ListingDetailsVC: UIViewController {

    @IBOutlet fileprivate weak var tagsViewHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var tagsView: UIView!
    @IBOutlet weak var PhysicalRadioButton: DLRadioButton!
    @IBOutlet weak var DigitalRadioButton: DLRadioButton!
    @IBOutlet weak var short_description: CustomTextField!
    @IBOutlet weak var descriptionTV: CustomTextField!
    @IBOutlet weak var titleTV: CustomTextField!
    @IBOutlet weak var materials: CustomTextField!
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var width: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!

    var type = "physical"
    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    var categeory = [Category]()
    var selectedCat = [Int]()
    var uploadedPhoto = [UIImage]()
    var images = [UIImage]()
    fileprivate let tagsField = WSTagsField()
    var typePickerView: UIPickerView = UIPickerView()
    var isFromEdit = false
    var product : ProductDetailsModel?
    
    var showCat = false
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PhysicalRadioButton.isSelected = true
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        tagsField.cornerRadius = 3.0
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding
        tagsField.placeholder = ""
        tagsField.placeholderColor = .red
        tagsField.placeholderAlwaysVisible = true
        tagsField.backgroundColor = .clear
        tagsField.textField.returnKeyType = .continue
        tagsField.delimiter = ""
        tagsField.tintColor = #colorLiteral(red: 0.9058823529, green: 0.9176470588, blue: 0.937254902, alpha: 1)
        tagsField.textColor = #colorLiteral(red: 0.1749513745, green: 0.2857730389, blue: 0.4644193649, alpha: 1)
        tagsField.textDelegate = self
        textFieldEvents()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        self.typePickerView.isHidden = true
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagsField.beginEditing()
        if isFromEdit{
            short_description.text = product?.shortDescription
            descriptionTV.text = product?.dataDescription
            titleTV.text = product?.title
            materials.text = product?.materials
            length.text = "\(product?.length ?? 0)"
            width.text = "\(product?.width ?? 0 )"
            weight.text = "\(product?.weight ?? 0)"
            height.text = "\(product?.height ?? 0)"
            for category in product?.categories ?? [] {
                self.selectedCat.append(category.id ?? 0 )
                self.tagsField.addTag(category.name ?? "")
            }
        }
        self.showCat = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsField.frame = tagsView.bounds
    }
    
    @IBAction func selectTypeAction(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            self.type = "physical"
        } else if sender.tag == 2 {
            self.type = "digital"
        }
    }
    
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func validateInput() -> Bool {
        let tags =  tagsField.tags.map({$0.text})
        let titles = self.titleTV.text ?? ""
        let shortDescription = self.short_description.text ?? ""
        let description = self.descriptionTV.text ?? ""
        
        if tags.count == 0  {
          self.showMessage(text: "Please Choose tags")
          return false
        }else if tags.count > 3  {
            self.showMessage(text: "Please No More than 3 tags")
            return false
          }else if titles.isEmpty {
            self.showMessage(text: "Please Enter title")
            return false
        }else if shortDescription.isEmpty {
            self.showMessage(text: "Please Enter short Description")
            return false
        }else if description.isEmpty {
            self.showMessage(text: "Please Enter Description")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else {return}
        if isFromEdit{
            let vc = InventoryPricingVC.instantiateFromNib()
            vc?.isFromEdit = true
            vc?.product = product
            vc!.selectedCat =  self.selectedCat
            vc!.titleTV = self.titleTV.text ?? ""
            vc!.short_description = self.short_description.text ?? ""
            vc!.descriptionTV = self.descriptionTV.text ?? ""
            vc!.length = self.length.text ?? ""
            vc!.width = self.width.text ?? ""
            vc!.materials = self.materials.text ?? ""
            vc!.weight = self.weight.text ?? ""
            vc!.height = self.height.text ?? ""
            vc!.type = self.type
            vc!.images = images
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
        let vc = InventoryPricingVC.instantiateFromNib()
        vc!.selectedCat =  self.selectedCat
        vc!.titleTV = self.titleTV.text ?? ""
        vc!.short_description = self.short_description.text ?? ""
        vc!.descriptionTV = self.descriptionTV.text ?? ""
        vc!.length = self.length.text ?? ""
        vc!.width = self.width.text ?? ""
        vc!.materials = self.materials.text ?? ""
        vc!.weight = self.weight.text ?? ""
        vc!.height = self.height.text ?? ""
        vc!.type = self.type
        vc!.uploadedPhoto = self.uploadedPhoto
        self.navigationController?.pushViewController(vc!, animated: true)
       }
    }
    
}

extension ListingDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagsField {
            self.typePickerView.isHidden = true
        }
        return true
    }
}

extension ListingDetailsVC {
    fileprivate func textFieldEvents() {

        tagsField.onDidAddTag = { field, tag in
            print("onDidAddTag", tag.text)
        }

        tagsField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
            self.selectedCat.removeLast()
        }
      
        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")
            let vc = ArtistNameVC.instantiateFromNib()
            vc?.showProductCat = true
            vc!.onClickCat = { cats in
            self.selectedCat.append(cats.id ?? 0 )
            self.tagsField.addTag(cats.name ?? "")
            self.presentingViewController?.dismiss(animated: true)
           }
            if self.showCat {
              self.present(vc!, animated: true, completion: nil)
            }
         }

        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
            self.tagsViewHeight.constant = height + 40
        }

        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }
        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
        tagsField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
