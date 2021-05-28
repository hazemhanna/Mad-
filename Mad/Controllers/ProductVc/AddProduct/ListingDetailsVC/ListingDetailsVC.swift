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
    var currencyArray = [String]()
    var uploadedPhoto = [UIImage]()
    var filteredStrings = [String]()
    fileprivate let tagsField = WSTagsField()
    var typePickerView: UIPickerView = UIPickerView()

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
        getCategory()
        productVM.showIndicator()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagsField.beginEditing()
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
        let tags =  self.selectedCat
        let titles = self.titleTV.text ?? ""
        let shortDescription = self.short_description.text ?? ""
        let description = self.descriptionTV.text ?? ""
        let materials = self.materials.text ?? ""
        let length = self.length.text ?? ""
        let width = self.width.text ?? ""
        let weight = self.weight.text ?? ""
        let height = self.height.text ?? ""

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
        }else if materials.isEmpty {
            self.showMessage(text: "Please Enter material")
            return false
        }else if length.isEmpty {
            self.showMessage(text: "Please Enter length")
            return false
        }else if width.isEmpty {
            self.showMessage(text: "Please Enter width")
            return false
        }else if weight.isEmpty {
            self.showMessage(text: "Please Enter weight")
            return false
        }else if height.isEmpty {
            self.showMessage(text: "Please Enter height")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        self.selectedCat.removeAll()
        let tags = tagsField.tags.map({$0.text})
        let uniqTags = tags.uniqued()
        for index in uniqTags{
            for cat in self.categeory{
                if index == cat.name{
                    self.selectedCat.append(cat.id ?? 0)
                }
            }
        }
        guard self.validateInput() else {return}
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
        }

        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")

            self.filteredStrings = self.currencyArray.filter({return $0.contains(text ?? "")})
            self.view.addSubview(self.typePickerView)
            self.typePickerView.frame = CGRect(x: 250, y: 100, width: 150, height: 160)
            self.typePickerView.delegate = self
            self.typePickerView.dataSource = self
            self.typePickerView.isHidden = true
            self.typePickerView.isHidden = false
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


// Number of columns
extension ListingDetailsVC : UIPickerViewDelegate, UIPickerViewDataSource {

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}
// Number of rows

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return filteredStrings.count // Number of rows = the amount in currency array
}

// Row Title

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
   return filteredStrings[row]
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    tagsField.addTag(filteredStrings[row])
    self.typePickerView.isHidden = true
  }
}

extension ListingDetailsVC {
     func getCategory() {
        productVM.getProductCategories().subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
                self.productVM.dismissIndicator()
                self.categeory = dataModel.data ?? []
                for cat in self.categeory{
                    self.currencyArray.append(cat.name ?? "")
                }
            }
        }, onError: { (error) in
            self.productVM.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
