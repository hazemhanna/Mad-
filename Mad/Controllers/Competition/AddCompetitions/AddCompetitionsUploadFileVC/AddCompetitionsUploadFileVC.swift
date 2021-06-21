//
//  AddCompetitionsUploadFileVC.swift
//  Mad
//
//  Created by MAC on 18/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar
import MobileCoreServices
import UniformTypeIdentifiers

class AddCompetitionsUploadFileVC: UIViewController {

    @IBOutlet weak var linkeTF : CustomTextField!

    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        let link = self.linkeTF.text ?? ""
       
        
        if link.isEmpty {
            self.showMessage(text: "Please Enter link")
            return false
        }else{
            return true
        }
    }
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else {return}
        let vc = SubmitCopetitionsVC.instantiateFromNib()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func uploadButton(sender: UIButton) {
        self.clickFunction()
    }
    
}

extension AddCompetitionsUploadFileVC : UIDocumentPickerDelegate,UINavigationControllerDelegate{
    func clickFunction(){
        let types: [String] = [(kUTTypeItem as String)]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
    }
          
    public func documentMenu(_ documentMenu:UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}
