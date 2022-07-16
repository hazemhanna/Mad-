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
        guard self.validateInput() else {return}
        let vc = CreatePackageVc.instantiateFromNib()
        vc!.selectedCat = selectedCat
        vc!.selectedArtist = selectedArtist
        vc!.locationTF = locationTF
        vc!.short_description = short_description
        vc!.titleTF = titleTF
        vc!.summeryTf = summeryTf
        vc!.startDateTf = startDateTf
        vc!.endDateTf = endDateTf
        vc!.contentHtml = editorTF.text ?? ""
        vc!.uploadedPhoto = uploadedPhoto
        vc!.selectedProducts = selectedProducts
        vc!.products = products
        vc?.projectDetails = projectDetails
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func uploadPhoto(sender: UIButton) {
        self.showImageActionSheet()
    }
    
    @IBAction func uploadImages(sender: UIButton) {
        self.showImageActionSheet()
    }
    
}

extension AboutProjectVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImageActionSheet() {

        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
                self.showImagePicker(sourceType: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "Take a Picture from Camera", style: .default) { (action) in
                self.showImagePicker(sourceType: .camera)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            AlertService.showAlert(style: .actionSheet, title: "Pick Your Picture", message: nil, actions: [chooseFromLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
        }
        dismiss(animated: true, completion: nil)
    }
    
}


