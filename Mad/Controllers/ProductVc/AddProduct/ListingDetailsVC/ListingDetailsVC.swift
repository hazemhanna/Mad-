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

    @IBOutlet fileprivate weak var tagsView: UIView!
    @IBOutlet weak var PhysicalRadioButton: DLRadioButton!
    @IBOutlet weak var DigitalRadioButton: DLRadioButton!
    @IBOutlet weak var short_description: UITextView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var titleTV: UITextView!
    @IBOutlet weak var materials: UITextView!
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var width: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!

    var type = String()
    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    var categeory = [Category]()
    var selectedCat = [Category]()
    var currencyArray = [String]()
    var uploadedPhoto = [UIImage]()

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
        tagsField.textDelegate = self
        textFieldEvents()
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
        
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        self.typePickerView.isHidden = true
        view.endEditing(true)
        let tags = tagsField.tags.map({$0.text})
        for cat in self.categeory{
            for index in tags {
                if index == cat.name{
                self.selectedCat.append(cat)
                }
            }
        }
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
            print("5")
        } else if sender.tag == 2 {
            print("4")
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton(sender: UIButton) {
        let vc = InventoryPricingVC.instantiateFromNib()
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
            self.typePickerView.isHidden = false
        }

        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
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
    return currencyArray.count // Number of rows = the amount in currency array
}

// Row Title

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
   return currencyArray[row]
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    tagsField.addTag(currencyArray[row])
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
                self.view.addSubview(self.typePickerView)
                self.typePickerView.frame = CGRect(x: 250, y: 100, width: 100, height: 160)
                self.typePickerView.delegate = self
                self.typePickerView.dataSource = self
                self.typePickerView.isHidden = true
                
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
