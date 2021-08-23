//
//  ProfileVc.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MyProfileVc: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var favouriteCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var  upgradeView : UIView!
    
    @IBOutlet weak var  logoBanner : UIImageView!
    @IBOutlet weak var  bannerBtn : UIButton!

    
    var active = Helper.getIsActive() ?? false
    var tokent = Helper.getAPIToken() ?? ""
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()

    var banner = false
    var profile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if active{
            upgradeView.isHidden = true
        }else{
            upgradeView.isHidden = false

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tokent != "" {
        artistVM.showIndicator()
        getProfile()
        }else{
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
            return
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func menuButton(sender: UIButton) {
        let main = MenuVC.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func upgradeButton(sender: UIButton) {
        let vc = EditMyProfileVc.instantiateFromNib()
        vc?.upgrad = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   
    @IBAction func profileButton(sender: UIButton) {
        self.profile = true
        showImageActionSheet()
    }
    
    @IBAction func bannerButton(sender: UIButton) {
        self.banner = true
        showImageActionSheet()
    }
    
}

extension MyProfileVc  {
    func getProfile() {
        artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.artistName.text = dataModel.data?.name ??  ""
            self.favouriteCount.text = "\(dataModel.data?.allFollowers ?? 0)"
            self.followersCount.text = "\(dataModel.data?.allFollowing ?? 0)"

            if let profile = URL(string:   dataModel.data?.profilPicture ??  "" ){
            self.ProfileImage.kf.setImage(with: profile, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
            if dataModel.data?.bannerImg != "" {
                self.bannerImage.isHidden = false
                if let bannerUrl = URL(string:   dataModel.data?.bannerImg ??  "" ){
                self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
            }else {
                self.bannerImage.isHidden = true
            }
          
         
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    func updateBanner(banner : UIImage) {
        artistVM.updateBanner(image: banner).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()

           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    func updateProfile(profile : UIImage) {
        artistVM.updateProfile(image: profile).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
}
extension MyProfileVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            if profile == true{
                self.profile = false
                self.updateProfile(profile: editedImage)
                self.ProfileImage.image = editedImage
            }else if banner == true{
                self.banner = false
                self.updateBanner(banner: editedImage)
                self.bannerImage.image = editedImage
                self.bannerImage.isHidden = false
            }
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if profile == true{
                self.profile = false
                self.updateProfile(profile: originalImage)
                self.ProfileImage.image = originalImage
            }else if banner == true{
                self.banner = false
                self.updateBanner(banner: originalImage)
                self.bannerImage.image = originalImage
                self.bannerImage.isHidden = false

            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}
