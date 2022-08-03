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

    @IBOutlet weak var bannerImage : UIImageView!
    @IBOutlet weak var linkeTF : CustomTextField!
    @IBOutlet weak var uploadBtn : UIButton!
    var compId = Int()
    var candidate:Candidate?
    var uploadImage = UIImage()
    var firstName = String()
    var lastName = String()
    var phoneNumber = String()
    var email = String()
    var artistName = String()
    var personal = String()
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkeTF.delegate = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.linkeTF.text = candidate?.videoLink ?? ""
        if let profileImageUrl = URL(string: candidate?.bannerImg ?? ""){
        self.bannerImage.kf.setImage(with: profileImageUrl, placeholder: #imageLiteral(resourceName: "Path 412"))
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton(sender: UIButton) {
        let vc = SubmitCopetitionsVC.instantiateFromNib()
        vc!.firstName = firstName
        vc!.lastName = lastName
        vc!.phoneNumber = phoneNumber
        vc!.email = email
        vc!.artistName = artistName
        vc!.personal = personal
        vc!.linke = self.linkeTF.text ?? ""
        vc!.uploadImage = uploadImage
        vc!.compId = compId
        vc!.candidate = candidate
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func uploadButton(sender: UIButton) {
        self.showImageActionSheet()
    }
}


extension AddCompetitionsUploadFileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            self.uploadImage = editedImage
            bannerImage.image = editedImage
            uploadBtn.isHidden = true
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.uploadImage = originalImage
            bannerImage.image = originalImage
            uploadBtn.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddCompetitionsUploadFileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
