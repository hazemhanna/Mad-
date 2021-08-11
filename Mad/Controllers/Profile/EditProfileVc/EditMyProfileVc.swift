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
    let cellIdentifier = "SocialCell"
    
    
    var active = Helper.getIsActive() ?? false
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var countries = [String]()
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    var social  = [socialMedia](){
        didSet{
            socialTableviewHieght.constant = CGFloat((40 * self.social.count))
            socialTableview.reloadData()
        }
    }

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.artistVM.showIndicator()
        getProfile()
        getCountry()
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
    
    
    @IBAction func saveButton(sender: UIButton) {


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
        return 40
    }

}

extension EditMyProfileVc {
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
     }
   }, onError: { (error) in
    self.artistVM.dismissIndicator()

   }).disposed(by: disposeBag)
}
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
}
