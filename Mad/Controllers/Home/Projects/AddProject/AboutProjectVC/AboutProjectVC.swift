//
//  AboutProjectVC.swift
//  Mad
//
//  Created by MAC on 02/06/2021.
//

import UIKit

class AboutProjectVC: UIViewController {

    @IBOutlet var editorTF: UITextField!
    var selectedCat = [Int]()
    var selectedArtist = [String]()
    var locationTF = String()
    var short_description = String()
    var titleTF = String()
    var summeryTf = String()
    var startDateTf = String()
    var endDateTf = String()
    var contentHtml = String()
    var uploadedPhoto :UIImage?
    var selectedProducts = [Int]()
    var products = [Product]()
    var projectDetails : ProjectDetails?

    var projectId = Int()

    override func viewDidLoad() {
        
            super.viewDidLoad()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        editorTF.text = projectDetails?.content ?? ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        if editorTF.text == ""{
            self.showMessage(text: "Please enter content of project")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        //guard self.validateInput() else {return}
        let vc = CreatePackageVc.instantiateFromNib()
        vc!.selectedCat = selectedCat
        vc!.selectedArtist = selectedArtist
        vc!.locationTF = locationTF
        vc!.short_description = locationTF
        vc!.titleTF = titleTF
        vc!.summeryTf = summeryTf
        vc!.startDateTf = startDateTf
        vc!.endDateTf = endDateTf
        vc!.contentHtml = editorTF.text ?? ""
        vc!.uploadedPhoto = uploadedPhoto
        vc!.selectedProducts = selectedProducts
        vc!.products = products
        vc?.projectId = projectId
        vc?.projectDetails = projectDetails
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}



