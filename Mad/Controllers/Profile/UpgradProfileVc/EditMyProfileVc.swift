//
//  EditMyProfileVc.swift
//  Mad
//
//  Created by MAC on 09/08/2021.
//


import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class EditMyProfileVc: UIViewController {
    
    @IBOutlet weak var  socialTableview : UITableView!
    @IBOutlet weak var  socialTableviewHieght : NSLayoutConstraint!
    @IBOutlet weak var selectCateDropDown: TextFieldDropDown!
    @IBOutlet weak var  firstNameTF : UITextField!
    @IBOutlet weak var  lastNameTF : UITextField!
    @IBOutlet weak var  ageTf : UITextField!
    @IBOutlet weak var  BiosTf : UITextField!
    @IBOutlet weak var  emailTf : UITextField!
    @IBOutlet weak var  phoneTf : UITextField!
    @IBOutlet weak var  headLineTf : UITextField!
    @IBOutlet weak var  facebookLink : UITextField!
    @IBOutlet weak var  facebooName : UITextField!
    @IBOutlet weak var  instgramLink : UITextField!
    @IBOutlet weak var  instgramName : UITextField!
    @IBOutlet weak var  twitterLink : UITextField!
    @IBOutlet weak var  twittweName : UITextField!
    @IBOutlet weak var  artistName : UITextField!
    @IBOutlet weak var  socialView : UIView!
    @IBOutlet weak var  headLineStack : UIStackView!
    @IBOutlet weak var  BiosStack : UIStackView!
    @IBOutlet weak var  lineView1 : UIView!
    @IBOutlet weak var  lineView2 : UIView!
    @IBOutlet fileprivate weak var tagsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var  joinLbl : UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var ProfileImage: UIImageView!
        
    @IBOutlet weak var musicBtn : UIButton!
    @IBOutlet weak var artBtn : UIButton!
    @IBOutlet weak var desigenBtn : UIButton!

    
    var selectedCat = [Int]()
    let cellIdentifier = "SocialCell"
    var active = Helper.getIsActive() ?? false
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var countries = [String]()
    var banner = false
    var profile = false
    var showCat = false
    
    var music = false
    var art = false
    var desigen = false

    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    var social  = [Social](){
        didSet{
            socialTableviewHieght.constant = CGFloat((30 * self.social.count))
            socialTableview.reloadData()
        }
    }

 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupContentTableView()
        twittweName.delegate = self
        instgramName.delegate = self
        instgramLink.delegate = self
        facebooName.delegate = self
        facebookLink.delegate = self
        headLineTf.delegate = self
        phoneTf.delegate = self
        emailTf.delegate = self
        BiosTf.delegate = self
        ageTf.delegate = self
        lastNameTF.delegate = self
        firstNameTF.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.artistVM.showIndicator()
        getProfile()
        getCountry()
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
    
    func setupCatDropDown(){
        selectCateDropDown.optionArray = self.countries
        selectCateDropDown.didSelect { (selectedText, index, id) in
            self.selectCateDropDown.text = selectedText
            Helper.saveCountry(id: self.countries[index])
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        let email =  self.emailTf.text ?? ""
        let phone =  self.phoneTf.text ?? ""
        let firstName =  self.firstNameTF.text ?? ""
        let lastName =  self.lastNameTF.text ?? ""
        let age =  self.ageTf.text ?? ""
        let selectCountry =  self.selectCateDropDown.text ?? ""
        let BiosTf = self.BiosTf.text ?? ""
        let name = self.artistName.text ?? ""

        let headLine =  self.headLineTf.text ?? ""
                if email.isEmpty {
                  self.showMessage(text: "Please Enter Your email")
                  return false
                }else if phone.isEmpty {
                    self.showMessage(text: "Please Enter Your phone")
                    return false
                  }else if firstName.isEmpty {
                    self.showMessage(text: "Please Enter Your first Name")
                    return false
                  }else if lastName.isEmpty {
                    self.showMessage(text: "Please Enter Your last Name")
                    return false
                  }else if age.isEmpty {
                    self.showMessage(text: "Please Enter Your age")
                    return false
                  }else if selectCountry.isEmpty {
                    self.showMessage(text: "Please Enter Your Country")
                    return false
                  }else if BiosTf.isEmpty {
                    self.showMessage(text: "Please Enter Bios")
                    return false
                  }else if headLine.isEmpty {
                    self.showMessage(text: "Please Enter Your headLine")
                    return false
                 }  else if name.isEmpty {
                    self.showMessage(text: "Please Enter Your Name")
                    return false
                 } else{
                    return true
                 }
          
    }
    
    
    @IBAction func saveButton(sender: UIButton) {
        guard self.validateInput() else { return }
        self.artistVM.showIndicator()
        self.upgradeProfile(email: self.emailTf.text ?? "", phone: self.phoneTf.text ?? "", firstName: self.firstNameTF.text ?? "", lastName: self.lastNameTF.text ?? "", age: self.ageTf.text ?? "", country: self.selectCateDropDown.text ?? "", about: self.BiosTf.text ?? "", headLine: self.headLineTf.text ?? "", instgram: self.instgramLink.text ?? "", faceBook: self.facebookLink.text ?? "", twitter: self.twitterLink.text ?? "",name:self.artistName.text ?? "" ,music:self.music,art:self.art,design:self.desigen)
    }
    
    
    @IBAction func addSocialButton(sender: UIButton) {
        socialView.isHidden = false
    }
  
    @IBAction func doneAddSocialButton(sender: UIButton) {
        socialView.isHidden = true
        if facebookLink.text != "" {
            social.append(Social(name: facebooName.text ?? "", url: facebookLink.text ?? "" , icon: "http://mad.cnepho.com/wp-content/plugins/MAD/img/facebook_mail.png" ))
        }
        if instgramLink.text != "" {
            social.append(Social(name: instgramName.text ?? "",  url: instgramLink.text ?? "" , icon: "http://mad.cnepho.com/wp-content/plugins/MAD/img/instagram_mail.png"))
        }
        if twitterLink.text != "" {
            social.append(Social(name: twittweName.text ?? "",  url: twitterLink.text ?? "" , icon: "" ))
        }
    
        facebooName.text = ""
        facebookLink.text = ""
        instgramName.text = ""
        instgramLink.text = ""
        twittweName.text = ""
        twitterLink.text = ""
    }
    
    @IBAction func editAction(sender: UIButton) {
        if sender.tag == 0 {
            firstNameTF.becomeFirstResponder()
        }else if sender.tag == 1 {
            lastNameTF.becomeFirstResponder()
        }else if sender.tag == 2 {
            emailTf.becomeFirstResponder()
        }else if sender.tag == 3 {
            phoneTf.becomeFirstResponder()
        }else if sender.tag == 4 {
            ageTf.becomeFirstResponder()
        }else if sender.tag == 5 {
            selectCateDropDown.becomeFirstResponder()
        }else if sender.tag == 6 {
            headLineTf.becomeFirstResponder()
        }else if sender.tag == 7 {
            BiosTf.becomeFirstResponder()
        }else if sender.tag == 8 {
            BiosTf.becomeFirstResponder()
        }
    }
    
    
    @IBAction func profileButton(sender: UIButton) {
        self.profile = true
        showImageActionSheet()
    }
    
    @IBAction func bannerButton(sender: UIButton) {
        self.banner = true
        showImageActionSheet()
    }
    
    
    @IBAction func musicButton(sender: UIButton) {
        if self.music {
            self.musicBtn.setImage(nil, for: .normal)
            self.music = false
        }else{
            self.musicBtn.setImage(#imageLiteral(resourceName: "icon - check (1)"), for: .normal)
            self.music = true
        }
    }
    
    @IBAction func artButton(sender: UIButton) {
        if self.art {
            self.artBtn.setImage(nil, for: .normal)
            self.art = false
        }else{
            self.artBtn.setImage(#imageLiteral(resourceName: "icon - check (1)"), for: .normal)
            self.art = true

        }
    }
    
    @IBAction func desigenButton(sender: UIButton) {
    if self.desigen  {
        self.desigenBtn.setImage(nil, for: .normal)
        self.desigen = false
    }else{
        self.desigenBtn.setImage(#imageLiteral(resourceName: "icon - check (1)"), for: .normal)
        self.desigen = true
      }
    }
    
}

extension EditMyProfileVc : UITableViewDelegate,UITableViewDataSource{
    func setupContentTableView() {
        
        socialTableview.delegate = self
        socialTableview.dataSource = self
        self.socialTableview.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return social.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! SocialCell
        cell.confic(name:  self.social[indexPath.row].name ?? "", icon: self.social[indexPath.row].icon ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

extension EditMyProfileVc {
    
    func getCountry() {
        artistVM.getAllCountries().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
               self.artistVM.dismissIndicator()
               self.countries = dataModel.data ?? []
               self.setupCatDropDown()
           }
       }, onError: { (error) in
           self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
func getProfile() {
    
    artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.artistVM.dismissIndicator()
        self.firstNameTF.text = dataModel.data?.firstName ??  ""
        self.lastNameTF.text = dataModel.data?.lastName ?? ""
        self.emailTf.text = dataModel.data?.userEmail ?? ""
        self.phoneTf.text = dataModel.data?.phone ?? ""
        self.selectCateDropDown.text = dataModel.data?.country ?? ""
        self.BiosTf.text = dataModel.data?.about ?? ""
        self.headLineTf.text = dataModel.data?.headline ?? ""
        self.social = dataModel.data?.socialLinks ?? []
        self.artistName.text = dataModel.data?.name ?? ""
        self.showCat = true
        if let profile = URL(string:   dataModel.data?.profilPicture ??  "" ){
        self.ProfileImage.kf.setImage(with: profile, placeholder: #imageLiteral(resourceName: "Group 172"))
        }
        
        if let bannerUrl = URL(string:   dataModel.data?.bannerImg ??  "" ){
            self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "Mask Group 121"))
        }
        
        self.music = dataModel.data?.music ?? false
        self.art = dataModel.data?.art ?? false
        self.desigen = dataModel.data?.design ?? false
        if dataModel.data?.music ?? false {
            self.musicBtn.setImage(#imageLiteral(resourceName: "icon - check (1)"), for: .normal)

        }else{
            self.musicBtn.setImage(nil, for: .normal)

        }
        
        if  dataModel.data?.art ?? false {
            self.artBtn.setImage(#imageLiteral(resourceName: "icon - check (1)"), for: .normal)

        }else{
            self.artBtn.setImage(nil, for: .normal)

        }
        
        if dataModel.data?.design ?? false  {
            self.desigenBtn.setImage(#imageLiteral(resourceName: "icon - check (1)"), for: .normal)

        }else{
            self.desigenBtn.setImage(nil, for: .normal)

        }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: dataModel.data?.userRegistered ?? "" )
        inputFormatter.dateFormat = "dd,MMMM,yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        self.joinLbl.text = "joined" + " " + resultString
        self.socialTableview.reloadData()
     }
   }, onError: { (error) in
    self.artistVM.dismissIndicator()

   }).disposed(by: disposeBag)
}
    
    func upgradeProfile(email : String,phone : String,firstName : String,lastName : String,age : String,country : String,about : String,headLine : String,instgram : String,faceBook : String,twitter : String,name:String,music:Bool,art:Bool,design:Bool) {
        artistVM.upgradeMyProfile(email: email, phone: phone, firstName: firstName, lastName: lastName, age: age, country: country, about: about, headLine: headLine, instgram: instgram, faceBook: faceBook, twitter: twitter,name:name,music:music,art:art,design:design).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
            //Helper.saveActive(isActive: dataModel.data?.activatedArtist ?? false)
            self.navigationController?.popViewController(animated: true)
           }else{
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
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

extension EditMyProfileVc: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension EditMyProfileVc : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
