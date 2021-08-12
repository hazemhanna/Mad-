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



struct socialMedia {
    let icon : UIImage?
    let name : String?
    let url : String?
    
}

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
    @IBOutlet weak var  socialView : UIView!
    @IBOutlet weak var  levelLbL : UILabel!
    @IBOutlet weak var  PointLbl : UILabel!
    @IBOutlet weak var  flowersLbl : UILabel!
    @IBOutlet weak var  flowingLbl : UILabel!
    
    @IBOutlet weak var  headLineStack : UIStackView!
    @IBOutlet weak var  BiosStack : UIStackView!
    @IBOutlet weak var  lineView1 : UIView!
    @IBOutlet weak var  lineView2 : UIView!

    
    let cellIdentifier = "SocialCell"
    var upgrad = false
    var active = Helper.getIsActive() ?? false
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var countries = [String]()
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    var social  = [socialMedia](){
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
     
        if active {
            BiosStack.isHidden = false
            headLineStack.isHidden = false
            lineView1.isHidden = false
            lineView2.isHidden = false
        }else{
            if upgrad{
                BiosStack.isHidden = false
                headLineStack.isHidden = false
                lineView1.isHidden = false
                lineView2.isHidden = false
            }else{
                BiosStack.isHidden = true
                headLineStack.isHidden = true
                lineView1.isHidden = true
                lineView2.isHidden = true
            }
        }
        
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
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
        let BiosTf =  self.BiosTf.text ?? ""
        let headLine =  self.headLineTf.text ?? ""
        if active{
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
             }else{
                return true
             }
        }else{
            if upgrad{
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
                 }else{
                    return true
                 }

            }else{
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
                  }else{
                    return true
                 }
            }
          }
    }
    
    
    @IBAction func saveButton(sender: UIButton) {
        guard self.validateInput() else { return }
        self.artistVM.showIndicator()
        if upgrad {
            self.upgradeProfile(email: self.emailTf.text ?? "", phone: self.phoneTf.text ?? "", firstName: self.firstNameTF.text ?? "", lastName: self.lastNameTF.text ?? "", age: self.ageTf.text ?? "", country: self.selectCateDropDown.text ?? "", about: self.BiosTf.text ?? "", headLine: self.headLineTf.text ?? "", instgram: self.instgramLink.text ?? "", faceBook: self.facebookLink.text ?? "", twitter: self.twitterLink.text ?? "")
        }else{
            self.updateProfile(email: self.emailTf.text ?? "", phone: self.phoneTf.text ?? "", firstName: self.firstNameTF.text ?? "", lastName: self.lastNameTF.text ?? "", age: self.ageTf.text ?? "", country: self.selectCateDropDown.text ?? "", about: self.BiosTf.text ?? "", headLine: self.headLineTf.text ?? "", instgram: self.instgramLink.text ?? "", faceBook: self.facebookLink.text ?? "", twitter: self.twitterLink.text ?? "", active: self.active)
        }
    }
    
    
    @IBAction func addSocialButton(sender: UIButton) {
        socialView.isHidden = false
    }
  
    @IBAction func doneAddSocialButton(sender: UIButton) {
        socialView.isHidden = true
        if facebookLink.text != "" {
            social.append(socialMedia(icon: #imageLiteral(resourceName: "Path 430"), name: facebooName.text ?? "" , url: facebookLink.text ?? ""))
        }
        if instgramLink.text != "" {
            social.append(socialMedia(icon: #imageLiteral(resourceName: "Group 350"),  name: instgramName.text ?? "" , url: instgramLink.text ?? ""))
        }
        if twitterLink.text != "" {
            social.append(socialMedia(icon: #imageLiteral(resourceName: "Path 429"),  name: twittweName.text ?? "" , url: twitterLink.text ?? ""))
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

        }else if sender.tag == 6 {
            BiosTf.becomeFirstResponder()
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
        cell.nameLbl.text = self.social[indexPath.row].name ?? ""
        cell.iconImage.image = self.social[indexPath.row].icon
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
        self.levelLbL.text = dataModel.data?.level ?? ""
        self.PointLbl.text = String(dataModel.data?.points ?? 0)
        self.flowersLbl.text = String(dataModel.data?.allFollowers ?? 0)
        self.flowingLbl.text = String(dataModel.data?.allFollowing ?? 0)

     }
   }, onError: { (error) in
    self.artistVM.dismissIndicator()

   }).disposed(by: disposeBag)
}
    
func updateProfile(email : String,phone : String,firstName : String,lastName : String,age : String,country : String,about : String,headLine : String,instgram : String,faceBook : String,twitter : String,active:Bool) {
        artistVM.updateProfile(email: email, phone: phone, firstName: firstName, lastName: lastName, age: age, country: country, about: about, headLine: headLine, instgram: instgram, faceBook: faceBook, twitter: twitter,active:active).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.firstNameTF.text = dataModel.data?.firstName ??  ""
            self.lastNameTF.text = dataModel.data?.lastName ?? ""
            self.emailTf.text = dataModel.data?.userEmail ?? ""
            self.phoneTf.text = dataModel.data?.phone ?? ""
            self.selectCateDropDown.text = dataModel.data?.country ?? ""
            self.BiosTf.text = dataModel.data?.about ?? ""
            self.headLineTf.text = dataModel.data?.headline ?? ""
            self.showMessage(text: dataModel.message ?? "")
         }else{
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()
       }).disposed(by: disposeBag)
    }
    
    func upgradeProfile(email : String,phone : String,firstName : String,lastName : String,age : String,country : String,about : String,headLine : String,instgram : String,faceBook : String,twitter : String) {
        artistVM.upgradeMyProfile(email: email, phone: phone, firstName: firstName, lastName: lastName, age: age, country: country, about: about, headLine: headLine, instgram: instgram, faceBook: faceBook, twitter: twitter).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.firstNameTF.text = dataModel.data?.firstName ??  ""
            self.lastNameTF.text = dataModel.data?.lastName ?? ""
            self.emailTf.text = dataModel.data?.userEmail ?? ""
            self.phoneTf.text = dataModel.data?.phone ?? ""
            self.selectCateDropDown.text = dataModel.data?.country ?? ""
            self.BiosTf.text = dataModel.data?.about ?? ""
            self.headLineTf.text = dataModel.data?.headline ?? ""
            Helper.saveActive(isActive: dataModel.data?.activatedArtist ?? false)
            self.showMessage(text: dataModel.message ?? "")
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
