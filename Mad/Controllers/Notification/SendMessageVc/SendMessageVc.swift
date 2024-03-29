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
    @IBOutlet weak var orderTitleTf : UITextField!

    var disposeBag = DisposeBag()
    var ChatVM = ChatViewModel()

    var artist :[Artist] = []
    var object :[String] = []
    var project :[Project] = []
    var Product :[Product] = []
    var objectName = String()
    var objectImage = String()
    var objectPrice = String()
    var subject = ["Product","Project","Order","Collaboration"]
    var selectedSubject = "Project"
    var objectId = String()
    var artistId = Int()
    var fromArtistPage = false
    var tagsField = WSTagsField()
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
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
        }
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if fromArtistPage{
            self.getArtistProfile(id: artistId)
        }
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
                self.selectProjectDropDown.isHidden = false
                self.orderTitleTf.isHidden = true
                
            }else if index == 1 {
                self.object.removeAll()
                self.titleLbl.text = "Choose Project"
                self.selectedSubject  = "Project"
                for index in self.project {
                    self.object.append(index.title ?? "")
                }
                
                self.selectProjectDropDown.isHidden = false
                self.orderTitleTf.isHidden = true
                
            }else if index == 2 {
                self.object.removeAll()
                self.titleLbl.text = "Type your chat Title here"
                self.selectedSubject  = "Order"
                self.selectProjectDropDown.isHidden = true
                self.orderTitleTf.isHidden = false
            }else if index == 3 {
                self.object.removeAll()
                self.titleLbl.text = "Type your chat Title here"
                self.selectedSubject  = "Collaboration"
                self.selectProjectDropDown.isHidden = true
                self.orderTitleTf.isHidden = false
            }
            self.setupObjectDropDown()
        }
    }
    
    func setupObjectDropDown(){
        selectProjectDropDown.optionArray = self.object
        selectProjectDropDown.didSelect { (selectedText, index, id) in
            self.selectProjectDropDown.text = selectedText
            if self.selectedSubject == "Product"{
                self.objectId = String(self.Product[index].id ?? 0)
                self.objectName = self.Product[index].title ?? ""
                self.objectImage = self.Product[index].imageURL ?? ""
                self.objectPrice = String(self.Product[index].price ?? 0)
            }else if self.selectedSubject == "Project"{
                self.objectId = String(self.project[index].id ?? 0)
                self.objectName = self.project[index].title ?? ""
                self.objectImage = self.project[index].imageURL ?? ""
            }
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        let subject =  self.selectSubjectDropDown.text ?? ""
        let object =  self.selectProjectDropDown.text ?? ""
        let title =  self.orderTitleTf.text ?? ""
        
        if subject.isEmpty {
          self.showMessage(text: "Please select subject")
          return false
        }else{
        if selectedSubject == "Project" || selectedSubject == "Product"{
            if object.isEmpty{
              self.showMessage(text: "Please select object")
                return false
            }
        }else if selectedSubject == "Order" || selectedSubject == "Collaboration"{
            if title.isEmpty{
              self.showMessage(text: "Please Enter Title")
                return false
            }
          }
            return true
        }
    }
    
    @IBAction func sendButton(sender: UIButton) {
      guard self.validateInput() else { return }
        self.ChatVM.showIndicator()
        if selectedSubject == "Order" ||  selectedSubject == "Collaboration" {
            creatConversation(subject: self.selectedSubject, artistId: self.artistId, subjectId: self.orderTitleTf.text ?? "")
        }else{
            creatConversation(subject: self.selectedSubject, artistId: self.artistId, subjectId: self.objectId)
        }
    }
}


extension SendMessageVc: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagsField {
            view.endEditing(true)
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
            let vc = ArtistNameVC.instantiateFromNib()
            vc?.showFavouritArtist = true
            vc!.onClickClose = { artist in
            self.tagsField.addTag(artist.name ?? "")
            self.getArtistProfile(id : artist.id ?? 0)
            self.artistId = artist.id ?? 0
            self.presentingViewController?.dismiss(animated: true)
           }
           self.present(vc!, animated: true, completion: nil)
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

extension SendMessageVc {
    func getArtistProfile(id : Int) {
        ChatVM.getArtistProfile(artistId: id).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.ChatVM.dismissIndicator()
            self.Product = dataModel.data?.products ?? []
            self.project = dataModel.data?.projects ?? []            
            self.object.removeAll()
            for index in self.project {
                self.object.append(index.title ?? "")
            }
            self.setupObjectDropDown()
         }
       }, onError: { (error) in
        self.ChatVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    func creatConversation(subject:String,artistId : Int,subjectId:String) {
        ChatVM.creatConversation(subject: subject, artistId: artistId, subjectId: subjectId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.ChatVM.dismissIndicator()
            let main = ChatVc.instantiateFromNib()
            main?.convId = dataModel.data?.id ?? 0
            main?.objectName = self.objectName
            main?.objectImage = self.objectImage
            main?.objectPrice = self.objectPrice
            main?.selectedSubject = self.selectedSubject
            self.navigationController?.pushViewController(main!, animated: true)
           }
       }, onError: { (error) in
        self.ChatVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    
}
