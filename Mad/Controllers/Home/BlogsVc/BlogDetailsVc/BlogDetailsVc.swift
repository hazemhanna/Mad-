//
//  BlogDetailsVc.swift
//  Mad
//
//  Created by MAC on 24/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class BlogDetailsVc : UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var screenTitleLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var aboutTV: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var contentSizeHieght : NSLayoutConstraint!

    var blogsVM = BlogsViewModel()
    var disposeBag = DisposeBag()
    var showShimmer: Bool = true
    var blogId = 0
    var isFavourite: Bool = false
    var token = Helper.getAPIToken() ?? ""

    let cellIdentifier = "LiveCellCVC"
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.blogsVM.showIndicator()
        screenTitleLbl.text = "blogDetails".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getBlogsDetails(blogId : self.blogId)
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func shareAction(_ sender: UIButton) {
        if Helper.getAPIToken() != "" {
            self.blogsVM.showIndicator()
            self.shareBlog(blogId : self.blogId)
        }else{
            displayMessage(title: "",message: "please login first".localized, status: .error, forController: self)
        }
    }
}


extension BlogDetailsVc :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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

extension BlogDetailsVc {
func getBlogsDetails(blogId : Int) {
    blogsVM.getBlogsDetails(blogId: blogId).subscribe(onNext: { (data) in
       if data.success ?? false {
        self.blogsVM.dismissIndicator()
        self.shareLbl.text = "\(data.data?.shareCount ?? 0)"
        self.aboutTV.text = data.data?.content?.html2String ?? ""
        self.titleLbl.text = data.data?.title ?? ""
        var projectCat = [String]()
        for cat in data.data?.categories ?? []{
            projectCat.append(cat.name ?? "")
        }
        self.typeLbl.text =   projectCat.joined(separator: ",")
        let height = self.aboutTV.intrinsicContentSize.height
        self.contentSizeHieght.constant = 450 + height
        if  let projectUrl = URL(string: data.data?.imageURL ?? ""){
        self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
      
       }
   }, onError: { (error) in
    self.blogsVM.dismissIndicator()
   }).disposed(by: disposeBag)
  }
    
    func shareBlog(blogId : Int) {
        blogsVM.shareBlogs(blogsId: blogId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.blogsVM.dismissIndicator()
            self.getBlogsDetails(blogId : blogId)
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)
            let text = self.titleLbl.text ?? ""
            let image = self.projectImage.image
            let textToShare = [text ,image] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
          activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
            
           }
       }, onError: { (error) in
        self.blogsVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
}

