//
//  SendMessageVc.swift
//  Mad
//
//  Created by MAC on 14/07/2021.
//

import UIKit
import DLRadioButton
import WSTagsField
import RxSwift
import RxCocoa
import PTCardTabBar

class SendMessageVc: UIViewController {
    
    @IBOutlet fileprivate weak var tagsViewHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var tagsView: UIView!
    @IBOutlet weak var selectSubjectDropDown: TextFieldDropDown!
    @IBOutlet weak var selectProjectDropDown: TextFieldDropDown!
    @IBOutlet weak var titleLbl: UILabel!

    var disposeBag = DisposeBag()
    var ChatVM = ChatViewModel()
    var artist :[Artist] = []
    var object :[String] = []
    var project :[Project] = []
    var Product :[Product] = []
    
    var filteredStrings = [String]()
    var subject = ["Product","Project","Order","Collaboration"]
    var selectedSubject = String()
    var objectId = Int()
    var artistId = Int()

    fileprivate let tagsField = WSTagsField()
    var typePickerView: UIPickerView = UIPickerView()
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        setupSubjectDropDown()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
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
    
    func setupSubjectDropDown(){
        selectSubjectDropDown.optionArray = self.subject
        selectSubjectDropDown.didSelect { (selectedText, index, id) in
            self.selectSubjectDropDown.text = selectedText
            if index == 0 {
                self.object.removeAll()
                self.titleLbl.text = "Choose Product"
                self.selectedSubject  = "Product"
                for index in self.Product {
                    self.object.append(index.title ?? "")
                }
            }else if index == 1 {
                self.object.removeAll()
                self.titleLbl.text = "Choose Project"
                self.selectedSubject  = "Project"
                for index in self.project {
                    self.object.append(index.title ?? "")
                }
            }else if index == 2 {
                self.object.removeAll()
                self.titleLbl.text = "Choose Order"
                self.selectedSubject  = ""

            }else if index == 3 {
                self.object.removeAll()
                self.titleLbl.text = "Choose Collaboration"
                self.selectedSubject  = ""

            }
            self.setupObjectDropDown()
        }
    }
    
    func setupObjectDropDown(){
        selectProjectDropDown.optionArray = self.object
        selectProjectDropDown.didSelect { (selectedText, index, id) in
            self.selectProjectDropDown.text = selectedText
            
            if self.selectedSubject == "Product"{
                self.objectId = self.Product[index].id ?? 0
            }else if self.selectedSubject == "Project"{
                self.objectId = self.project[index].id ?? 0
            }
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        let subject =  self.selectSubjectDropDown.text ?? ""
        let object =  self.selectProjectDropDown.text ?? ""
        if subject.isEmpty {
          self.showMessage(text: "Please select subject")
          return false
        }else if object.isEmpty {
          self.showMessage(text: "Please select object")
          return false
        }else{
            return true
        }
        
    }
    @IBAction func sendButton(sender: UIButton) {
      guard self.validateInput() else { return }
        self.ChatVM.showIndicator()
        creatConversation(subject: self.selectedSubject, artistId: self.artistId, subjectId: self.objectId)
    }
}


extension SendMessageVc: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagsField {
            self.typePickerView.isHidden = true
        }
        return true
    }
}

extension SendMessageVc {
    fileprivate func textFieldEvents() {
        
        tagsField.onDidAddTag = { field, tag in
            print("onDidAddTag", tag.text)
        }
        
        tagsField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
        }

        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")
            self.getAllArtist(section : "artists",search:text ?? "",pageNum :1)

            self.view.addSubview(self.typePickerView)
            self.typePickerView.frame = CGRect(x: 200, y: 100, width: 150, height: 160)
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
extension SendMessageVc : UIPickerViewDelegate, UIPickerViewDataSource {

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
    self.ChatVM.showIndicator()
    self.artistId = artist[row].id ?? 0
    getArtistProfile(id: artist[row].id ?? 0)
     view.endEditing(true)
  }
}

extension SendMessageVc {
    func getAllArtist(section : String,search:String,pageNum :Int) {
        ChatVM.getSearchArtist(section : section,search:search,pageNum :pageNum).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.ChatVM.dismissIndicator()
            self.artist = dataModel.data ?? []
            for index in dataModel.data ?? [] {
                self.filteredStrings.append(index.name ?? "")
            }
           }
       }, onError: { (error) in
        self.ChatVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }

    
    func getArtistProfile(id : Int) {
        ChatVM.getArtistProfile(artistId: id).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.ChatVM.dismissIndicator()
            self.Product = dataModel.data?.products ?? []
            self.project = dataModel.data?.projects ?? []
         }
       }, onError: { (error) in
        self.ChatVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    
    func creatConversation(subject:String,artistId : Int,subjectId:Int) {
        ChatVM.creatConversation(subject: subject, artistId: artistId, subjectId: subjectId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.ChatVM.dismissIndicator()
            let main = ChatVc.instantiateFromNib()
            main?.convId = dataModel.data?.id ?? 0
            self.navigationController?.pushViewController(main!, animated: true)
           }
       }, onError: { (error) in
        self.ChatVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
}

