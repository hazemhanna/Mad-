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
    
    @IBOutlet weak var  socialcollection : UICollectionView!
    @IBOutlet weak var  firstNameTF : UITextField!
    @IBOutlet weak var  lastNameTF : UITextField!
    @IBOutlet weak var  ageTf : UITextField!
    @IBOutlet weak var  BiosTf : UITextField!
    @IBOutlet weak var  phoneTF : UITextField!
    @IBOutlet weak var  headLineTF : UITextField!
    @IBOutlet weak var  facebookLink : UITextField!
    @IBOutlet weak var  facebooName : UITextField!
    @IBOutlet weak var  instgramLink : UITextField!
    @IBOutlet weak var  instgramName : UITextField!
    @IBOutlet weak var  twitterLink : UITextField!
    @IBOutlet weak var  twittweName : UITextField!
    @IBOutlet weak var  socialView : UIView!
    @IBOutlet weak var  joinLbl : UILabel!
    @IBOutlet weak var  follwersLbl : UILabel!
    @IBOutlet weak var  followingLbl : UILabel!
    @IBOutlet weak var  pointLbl : UILabel!
    
    @IBOutlet weak var  musiccatBtn : UIButton!
    @IBOutlet weak var  artcatBtn: UIButton!
    @IBOutlet weak var  designcatBtn: UIButton!
    
    let cellIdentifier = "SocialMediaCell"
    var active = Helper.getType() ?? false

    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    
    var music = false
    var art = false
    var design  = false
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    var social  = [Social](){
        didSet{
            socialcollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twittweName.delegate = self
        instgramName.delegate = self
        instgramLink.delegate = self
        facebooName.delegate = self
        facebookLink.delegate = self
        BiosTf.delegate = self
        ageTf.delegate = self
        lastNameTF.delegate = self
        firstNameTF.delegate = self
        phoneTF.delegate = self
        headLineTF.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.artistVM.showIndicator()
        getProfile()
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
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        let firstName =  self.firstNameTF.text ?? ""
        let lastName =  self.lastNameTF.text ?? ""
        let age =  self.ageTf.text ?? ""
        let BiosTf = self.BiosTf.text ?? ""
        let phoneTF = self.phoneTF.text ?? ""
        let headLineTF = self.headLineTF.text ?? ""

        if firstName.isEmpty {
                    self.showMessage(text: "Please Enter Your first Name")
                    return false
                  }else if lastName.isEmpty {
                    self.showMessage(text: "Please Enter Your last Name")
                    return false
                  }else if age.isEmpty {
                    self.showMessage(text: "Please Enter Your age")
                    return false
                  }else if BiosTf.isEmpty {
                    self.showMessage(text: "Please Enter Bios")
                    return false
                  }else if phoneTF.isEmpty {
                      self.showMessage(text: "Please Enter Phone")
                      return false
                  }else if headLineTF.isEmpty {
                      self.showMessage(text: "Please Enter headline")
                      return false
                  }else{
                    return true
        }
          
    }
    
    @IBAction func saveButton(sender: UIButton) {
        guard self.validateInput() else { return }
        self.artistVM.showIndicator()
        if  active {
        self.updateProfile(firstName: self.firstNameTF.text ?? "", lastName: self.lastNameTF.text ?? "", age: self.ageTf.text ?? "", about: self.BiosTf.text ?? "", instgram: self.instgramLink.text ?? "", faceBook: self.facebookLink.text ?? "", twitter: self.twitterLink.text ?? "", phone: self.phoneTF.text ?? "" , headLine : self.headLineTF.text ?? "",music : music,art : art,design : design)
        }else{
            self.upgradeProfile(firstName: self.firstNameTF.text ?? "", lastName: self.lastNameTF.text ?? "", age: self.ageTf.text ?? "", about: self.BiosTf.text ?? "", instgram: self.instgramLink.text ?? "", faceBook: self.facebookLink.text ?? "", twitter: self.twitterLink.text ?? "", phone: self.phoneTF.text ?? "" , headLine : self.headLineTF.text ?? "",music : music,art : art,design : design)
        }
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
            phoneTF.becomeFirstResponder()
        }else if sender.tag == 3 {
            ageTf.becomeFirstResponder()
        }else if sender.tag == 4 {
            BiosTf.becomeFirstResponder()
        }else if sender.tag == 5 {
            headLineTF.becomeFirstResponder()
        }
    }
    
    @IBAction func musicAction(sender: UIButton) {
        if music{
            self.music = false
            self.musiccatBtn.setImage(UIImage(named: "Ellipse 21"), for: .normal)
        }else{
            self.music = true
            self.musiccatBtn.setImage(UIImage(named: "Ellipse 22"), for: .normal)
        }
    }
    
    @IBAction func artAction(sender: UIButton) {
        if art {
            self.art = false
           self.artcatBtn.setImage(UIImage(named: "Ellipse 21"), for: .normal)
        }else{
            self.art = true
           self.artcatBtn.setImage(UIImage(named: "Ellipse 22"), for: .normal)
        }
    }

    @IBAction func designAction(sender: UIButton) {
        if design{
            self.design = false
          self.designcatBtn.setImage(UIImage(named: "Ellipse 21"), for: .normal)
        }else{
            self.design = true
          self.designcatBtn.setImage(UIImage(named: "Ellipse 22"), for: .normal)
        }
    }

}
extension EditMyProfileVc : UICollectionViewDelegate ,UICollectionViewDataSource{

    func setupContentTableView() {
        socialcollection.delegate = self
        socialcollection.dataSource = self
        self.socialcollection.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: self.cellIdentifier)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return social.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SocialMediaCell
        cell.confic(name : self.social[indexPath.row].name ?? "" ,icon : self.social[indexPath.row].icon ?? "")
        cell.details = {
            if let url = self.social[indexPath.row].url {
            Helper.UIApplicationURL.openUrl(url: url)
            }
        }
        return cell
    }
}

extension EditMyProfileVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
      let size:CGFloat = (collectionView.frame.size.width - space) / 9
          return CGSize(width: size, height: (collectionView.frame.size.height))
    }
}

extension EditMyProfileVc {
  func getProfile() {
    artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.artistVM.dismissIndicator()
        self.firstNameTF.text = dataModel.data?.firstName ??  ""
        self.lastNameTF.text = dataModel.data?.lastName ?? ""
        self.ageTf.text = String(dataModel.data?.age ?? 0)
        self.BiosTf.text = dataModel.data?.about ?? ""
        self.social = dataModel.data?.socialLinks ?? []
        self.follwersLbl.text = String(dataModel.data?.allFollowers ?? 0)
        self.followingLbl.text = String(dataModel.data?.allFollowing ?? 0)
        self.pointLbl.text = String(dataModel.data?.points ?? 0)
        self.phoneTF.text = String(dataModel.data?.phone ?? " ")
        self.headLineTF.text = String(dataModel.data?.headline ?? "")

        if  dataModel.data?.music ?? false {
            self.music = true
            self.musiccatBtn.setImage(UIImage(named: "Ellipse 22"), for: .normal)
        }
           
        if dataModel.data?.art ?? false {
            self.art = true
           self.artcatBtn.setImage(UIImage(named: "Ellipse 22"), for: .normal)
        }
           
        if  dataModel.data?.design ?? false {
            self.design = true
          self.designcatBtn.setImage(UIImage(named: "Ellipse 22"), for: .normal)
        }
           
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: dataModel.data?.userRegistered ?? "" )
        inputFormatter.dateFormat = "dd,MMMM,yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        self.joinLbl.text = "joined" + " " + resultString
        self.socialcollection.reloadData()
           
     }
   }, onError: { (error) in
    self.artistVM.dismissIndicator()

   }).disposed(by: disposeBag)
}

    func upgradeProfile(firstName : String,lastName : String,age : String,about : String,instgram : String,faceBook : String,twitter : String , phone : String,headLine : String,music : Bool,art : Bool,design : Bool) {
        artistVM.upgradeMyProfile(firstName: firstName, lastName: lastName, age: age,about: about,instgram: instgram, faceBook: faceBook, twitter: twitter,phone : phone,headLine : headLine,music : music,art : art,design : design).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
            Helper.saveUpgrade(isActive: true)
            self.navigationController?.popViewController(animated: true)
           }else{
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()
       }).disposed(by: disposeBag)
    }
    
    func updateProfile(firstName : String,lastName : String,age : String,about : String,instgram : String,faceBook : String,twitter : String , phone : String,headLine : String,music : Bool,art : Bool,design : Bool) {
        artistVM.updateProfile(firstName: firstName, lastName: lastName, age: age,about: about,instgram: instgram, faceBook: faceBook, twitter: twitter,phone : phone,headLine : headLine,music : music,art : art,design : design).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
            self.navigationController?.popViewController(animated: true)
           }else{
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
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

