//
//  ProjectDetailsVC.swift
//  Mad
//
//  Created by MAC on 15/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class ProjectDetailsVC: UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var LikeLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var aboutTV: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var contentSizeHieght : NSLayoutConstraint!
    @IBOutlet weak var descriptionBtn: UIButton!
    @IBOutlet weak var reviewsBtn: UIButton!
    @IBOutlet weak var reviewsStack : UIStackView!

    
    var homeVM = HomeViewModel()
    var disposeBag = DisposeBag()
    var showShimmer: Bool = true
    var projectId = 0
    var isFavourite: Bool = false
    var token = Helper.getAPIToken() ?? ""
    var reviews = [Review]()
    private let cellIdentifier2 = "ReviewCell"

    let cellIdentifier = "LiveCellCVC"
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.homeVM.showIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true       
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getProjectDetails(productID : self.projectId)
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    @IBAction func descriptionBtn(sender: UIButton) {
        if sender.tag == 1 {
            reviewsBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            descriptionBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            aboutView.isHidden = false
            reviewsStack.isHidden = true
        }else{
            descriptionBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            reviewsBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            aboutView.isHidden = true
            reviewsStack.isHidden = false
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        if Helper.getAPIToken() != nil {
        self.homeVM.showIndicator()
        if  self.isFavourite {
            self.editFavourite(productID:  self.projectId, Type: false)
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)
        }else{
            self.editFavourite(productID:  self.projectId, Type: true)
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
          }
        }else{
            self.showMessage(text: "please login first")
                let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                if let appDelegate = UIApplication.shared.delegate {
                    appDelegate.window??.rootViewController = sb
                }
           
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        if Helper.getAPIToken() != nil {
            self.shareProject(productID : self.projectId)

        }else{
            self.showMessage(text: "please login first")
            self.showMessage(text: "please login first")
                let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                if let appDelegate = UIApplication.shared.delegate {
                    appDelegate.window??.rootViewController = sb
                }
        }
    }
}



extension ProjectDetailsVC :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.showShimmer ? 2 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LiveCellCVC
        cell.showShimmer = showShimmer
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    
        let size:CGFloat = (collectionView.frame.size.width - space) / 1.4
            return CGSize(width: size, height: (collectionView.frame.size.height))
        }
}

extension ProjectDetailsVC {
func getProjectDetails(productID : Int) {
    homeVM.getProjectDetails(productID: productID).subscribe(onNext: { (data) in
       if data.success ?? false {
        self.homeVM.dismissIndicator()
        
        self.LikeLbl.text = "\(data.data?.favoriteCount ?? 0)"
        self.shareLbl.text = "\(data.data?.shareCount ?? 0)"
        self.aboutTV.text = data.data?.content?.html2String ?? ""
        self.titleLbl.text = data.data?.title ?? ""
        var projectCat = [String]()
        for cat in data.data?.categories ?? []{
            projectCat.append(cat.name ?? "")
        }
        self.typeLbl.text =   projectCat.joined(separator: ",")
        self.isFavourite = data.data?.isFavorite ?? false
        let height = self.aboutTV.intrinsicContentSize.height
        self.contentSizeHieght.constant = 450 + height
        if  let projectUrl = URL(string: data.data?.imageURL ?? ""){
        self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
        if data.data?.isFavorite ?? false {
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)
          }
       }
   }, onError: { (error) in
    self.homeVM.dismissIndicator()
   }).disposed(by: disposeBag)
  }
    
    
    func editFavourite(productID : Int,Type : Bool) {
        homeVM.addToFavourite(productID: productID, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.getProjectDetails(productID : productID)
            self.homeVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.homeVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    
    
    func shareProject(productID : Int) {
        homeVM.shareProject(productID: productID).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.homeVM.dismissIndicator()
            self.getProjectDetails(productID : productID)
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.homeVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
}

