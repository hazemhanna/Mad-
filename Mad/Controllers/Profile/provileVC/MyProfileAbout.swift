//
//  MyProfileAbout.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//



import UIKit
import RxSwift
import RxCocoa

class MyProfileAbout : UIViewController {

    @IBOutlet weak var  levelLbl: UILabel!
    @IBOutlet weak var  pointLbl: UILabel!
    @IBOutlet weak var  bioLbL : UILabel!
    @IBOutlet weak var  socilaLbL : UILabel!
    @IBOutlet weak var  typeLbl : UILabel!
    @IBOutlet weak var  joinLbl : UILabel!
    @IBOutlet weak var  socialcollection : UICollectionView!
    @IBOutlet weak var  bioStack : UIStackView!
    @IBOutlet weak var  catStack : UIStackView!
    @IBOutlet weak var  catLbl : UILabel!
    @IBOutlet weak var  headLineStack : UIStackView!
    @IBOutlet weak var  headLineLbl : UILabel!
    @IBOutlet weak var  editBtn : UILabel!
    @IBOutlet weak var  musiccatLabl: UILabel!
    @IBOutlet weak var  artcatLabl: UILabel!
    @IBOutlet weak var  designcatLabl: UILabel!
    
    let cellIdentifier = "SocialMediaCell"
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var active = Helper.getIsActive() ?? false
    var social  = [Social]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if active{
            socilaLbL.isHidden = false
            socialcollection.isHidden = false
            bioStack.isHidden = false
            headLineStack.isHidden = false
            catStack.isHidden = false
            typeLbl.text = "Mad Artist"
            editBtn.text = "Edit Artist Profile"
        }else{
            socilaLbL.isHidden = true
            socialcollection.isHidden = true
            bioStack.isHidden = true
            headLineStack.isHidden = true
            catStack.isHidden = true
            typeLbl.text = "Mader"
            editBtn.text = "Edit Profile"
        }
        getProfile()
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func editProfile(sender: UIButton) {
        if active{
            let vc = EditMyProfileVc.instantiateFromNib()
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = EditUSerProfileVc.instantiateFromNib()
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension MyProfileAbout : UICollectionViewDelegate ,UICollectionViewDataSource{

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

extension MyProfileAbout : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           // return CGSize(width: 30, height: 30)
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
      let size:CGFloat = (collectionView.frame.size.width - space) / 9
          return CGSize(width: size, height: (collectionView.frame.size.height))
    }
}
    
extension MyProfileAbout  {
    func getProfile() {
        artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {

            self.pointLbl.text = "\(dataModel.data?.points ?? 0)"
            self.levelLbl.text = dataModel.data?.level ?? ""
            self.social = dataModel.data?.socialLinks ?? []
            self.headLineLbl.text = dataModel.data?.headline ?? ""
            self.bioLbL.text = dataModel.data?.about ?? ""
               
               if  dataModel.data?.music ?? false {
                   self.musiccatLabl.text = "  Music  "
               }
               if  dataModel.data?.art ?? false {
                   self.artcatLabl.text = "  Art  "
               }
               if  dataModel.data?.design ?? false {
                   self.designcatLabl.text = "  Design  "
               }
               
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let showDate = inputFormatter.date(from: dataModel.data?.userRegistered ?? "" )
            inputFormatter.dateFormat = "dd,MMMM,yyyy"
             if let date = showDate {
            let resultString = inputFormatter.string(from: date)
                self.joinLbl.text = resultString
            }
            self.socialcollection.reloadData()
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
