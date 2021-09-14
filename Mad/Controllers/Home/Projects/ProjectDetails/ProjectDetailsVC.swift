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
import SwiftSoup


class ProjectDetailsVC: UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var artistCollectionView: UICollectionView!
    
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var artistView: UIView!
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
    @IBOutlet weak var taggedBtn: UIButton!
    @IBOutlet weak var reviewsStack : UIStackView!
    @IBOutlet weak var mainTitleLbl: UILabel!
    
    private let cellIdentifier = "LiveCellCVC"
    private let cellIdentifier2 = "ProjectCell"
    private let cellIdentifier3 = "AddsCell"

    
    
    var homeVM = HomeViewModel()
    var disposeBag = DisposeBag()
    var showShimmer: Bool = true
    var projectId = 0
    var isFavourite: Bool = false
    var token = Helper.getAPIToken() ?? ""
    var reviews = [Review]()
    var imagesHtml = [String?]()
    var product  = [Product]()
    var artists   = [Artist]()

  
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        
        self.artistCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)

        artistCollectionView.delegate = self
        artistCollectionView.dataSource = self
        
        
        self.imageCollectionView.register(UINib(nibName: cellIdentifier3, bundle: nil), forCellWithReuseIdentifier: cellIdentifier3)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        
        
        self.homeVM.showIndicator()
        mainTitleLbl.text = "Project.title".localized
        descriptionBtn.setTitle("About".localized, for: .normal)
        reviewsBtn.setTitle("Comment".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imageCollectionView.isHidden = true
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
            descriptionBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            reviewsBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            taggedBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            aboutView.isHidden = false
            reviewsStack.isHidden = true
            artistView.isHidden = true
            let height = self.aboutTV.intrinsicContentSize.height
            self.contentSizeHieght.constant = 800 + height
          //  self.productView.isHidden = false

        }else if sender.tag == 2{
            descriptionBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            taggedBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            reviewsBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            aboutView.isHidden = true
            reviewsStack.isHidden = true
            artistView.isHidden = false
            self.contentSizeHieght.constant = 800
           // self.productView.isHidden = true

        }else{
            descriptionBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            taggedBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            reviewsBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            aboutView.isHidden = true
            reviewsStack.isHidden = false
            artistView.isHidden = true
            self.contentSizeHieght.constant = 800
//            self.productView.isHidden = true

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
            let text = self.aboutTV.text ?? ""
            let image = self.projectImage.image ?? #imageLiteral(resourceName: "Component 63 – 1")
            let textToShare = [ text ,image] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
          activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
            
        }else{
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
       if collectionView == imageCollectionView{
        return imagesHtml.count
       }else if collectionView ==  artistCollectionView{
        return artists.count
    }else{
        return self.showShimmer ? 2 : product.count
    }

}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier3, for: indexPath) as! AddsCell
            
            if imagesHtml.count > 0 {
            if let url = URL(string: imagesHtml[indexPath.row] ?? ""){
               cell.photo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Mask Group 32"))
            }
            }
            return cell
        }else if collectionView ==  artistCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! ProjectCell

            if !self.showShimmer {
                    cell.catImage.isHidden = false
                    cell.addProjectBtn.isHidden = true
                    cell.projectNameLabel.text = self.artists[indexPath.row].name ?? ""
                    cell.ProjectView.layer.cornerRadius = 20
                    if let url = URL(string:   self.artists[indexPath.row].profilPicture ?? ""){
                    cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
                }
            
            }
             cell.showShimmer = showShimmer
            return cell
        
    }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LiveCellCVC
            if !self.showShimmer {
                cell.priceLbl.text = "USD \(self.product[indexPath.row].price ?? 0.0)"
                cell.titleLabel.text = self.product[indexPath.row].title ?? ""

                if let bannerUrl = URL(string:   self.product[indexPath.row].imageURL ?? ""){
                cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
                cell.editBtn.isHidden = true
            }
            
            cell.showShimmer = showShimmer
            return cell
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showShimmer {return}
        if collectionView == artistCollectionView {
        let vc = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProfileVc")  as! ArtistProfileVc
            vc.artistId = self.artists[indexPath.row].id ?? 0
            Helper.saveArtistId(id: self.artists[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)

        if collectionView == imageCollectionView {
            let size:CGFloat = (collectionView.frame.size.width - space) / 2
            return CGSize(width: size, height: (collectionView.frame.size.height) / 2)
        }else if collectionView == artistCollectionView{
            let size:CGFloat = (collectionView.frame.size.width - space) / 3.3
            return CGSize(width: size, height: 100)
            
      }else {
        let size:CGFloat = (collectionView.frame.size.width - space) / 1.4
            return CGSize(width: size, height: (collectionView.frame.size.height))
        }
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
        self.product = data.data?.products ?? []
        self.artists = data.data?.tagged ?? []
        self.showShimmer = false
//        if data.data?.products?.count ?? 0 > 0 {
//            //self.productView.isHidden = false
//            self.productCollectionView.reloadData()
//            let height = self.aboutTV.intrinsicContentSize.height
//            self.contentSizeHieght.constant = 900 + height
//        }else{
//           // self.productView.isHidden = true
//            let height = self.aboutTV.intrinsicContentSize.height
//            self.contentSizeHieght.constant = 600 + height
//        }
        
        let height = self.aboutTV.intrinsicContentSize.height
        self.contentSizeHieght.constant = 600 + height
        if data.data?.tagged?.count ?? 0 > 0 {
            self.artistCollectionView.isHidden = false
            self.artistCollectionView.reloadData()
        }
        
        self.titleLbl.text = data.data?.title ?? ""
        var projectCat = [String]()
        for cat in data.data?.categories ?? []{
            projectCat.append(cat.name ?? "")
        }
        self.typeLbl.text =   projectCat.joined(separator: ",")
        self.isFavourite = data.data?.isFavorite ?? false
        if  let projectUrl = URL(string: data.data?.imageURL ?? ""){
        self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
        if data.data?.isFavorite ?? false {
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)
          }
        
        do {
            let doc: Document = try SwiftSoup.parse(data.data?.content ?? "")
            let srcs: Elements = try doc.select("img[src]")
            let srcsStringArray: [String?] = srcs.array().map { try? $0.attr("src").description }
            print(srcsStringArray)
            if srcsStringArray.count > 0 {
                self.imageCollectionView.isHidden = false
                self.imagesHtml = srcsStringArray
                self.imageCollectionView.reloadData()
        }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
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

