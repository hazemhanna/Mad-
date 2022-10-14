//
//  ProductDetailsVC.swift
//  Mad
//
//  Created by MAC on 03/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar
import FirebaseDynamicLinks

class ProductDetailsVC: UIViewController {

    @IBOutlet weak var addsCollectionView: UICollectionView!
    @IBOutlet weak var relatedProductCollectionView: UICollectionView!
    @IBOutlet weak var photoCount: UILabel!
    @IBOutlet weak var photoIndex: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var producttitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favouritBtn: UIButton!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistPhoto: UIImageView!
    @IBOutlet weak var contentSizeHieght : NSLayoutConstraint!
    @IBOutlet weak var cartCount: UILabel!
    @IBOutlet weak var CounterLbl: UILabel!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var hideCartBtn: UIButton!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var productdescription: UILabel!
    @IBOutlet weak var descriptionBtn: UIButton!
    @IBOutlet weak var reviewsBtn: UIButton!
    @IBOutlet weak var descriptionStack: UIStackView!
    @IBOutlet weak var reviewsStack : UIStackView!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var detailsStack: UIStackView!
    @IBOutlet weak var reviewsStackSizeHieght : NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var viewCartBtn: UIButton!
    @IBOutlet weak var writeReviewBtn: UIButton!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var tagseLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var addToCartLbl: UILabel!
    @IBOutlet weak var addToCartBtn : UIButton!
    @IBOutlet weak var typeIcon : UIImageView!

    
    @IBOutlet weak var userStack : UIStackView!
    @IBOutlet weak var artistStack : UIStackView!

    var isFromProfile: Bool = false

    var token = Helper.getAPIToken() ?? ""
    var productId = Int()
    var showShimmer: Bool = true
    var showShimmer2: Bool = true
    var isFavourite: Bool = false
    var counter = 1
    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    var photos = [String]()
    var reviews = [Review]()
    var add = true
    var Products = [Product]() {
        didSet {
            DispatchQueue.main.async {
                self.relatedProductCollectionView?.reloadData()
            }
        }
    }
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
   private let CellIdentifier = "LiveCellCVC"
   private let cellIdentifier = "AddsCell"
   private let cellIdentifier2 = "ReviewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.relatedProductCollectionView.register(UINib(nibName: CellIdentifier, bundle: nil), forCellWithReuseIdentifier: CellIdentifier)
        showShimmer = false
        addsCollectionView.delegate = self
        addsCollectionView.dataSource = self
        addsCollectionView.isPagingEnabled = true
        relatedProductCollectionView.delegate = self
        relatedProductCollectionView.dataSource = self
        reviewsStack.isHidden = true
        setupContentTableView()
        contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        descriptionBtn.setTitle("description".localized, for: .normal)
        reviewsBtn.setTitle("review".localized, for: .normal)
        writeReviewBtn.setTitle("WriteReview".localized, for: .normal)
        viewCartBtn.setTitle("View.cart".localized, for: .normal)
       // phsicalLbl.text = "Physical".localized
        addToCartLbl.text = "addedToCart".localized

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
        blackView.isHidden = true
        reviewsBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
        descriptionBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
        detailsBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
        detailsStack.isHidden = false
        reviewsStack.isHidden = true
        descriptionStack.isHidden = true
        
        if isFromProfile {
            userStack.isHidden = true
            artistStack.isHidden = false
        }else{
            userStack.isHidden = false
            artistStack.isHidden = true
        }

        
    }
    override func viewDidAppear(_ animated: Bool) {
        productVM.showIndicator()
        getproductDetails(id: self.productId)
        self.getCart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func descriptionBtn(sender: UIButton) {
        if sender.tag == 0 {
            reviewsBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            descriptionBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            detailsBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            detailsStack.isHidden = false
            reviewsStack.isHidden = true
            descriptionStack.isHidden = true
            contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            let height = self.producttitle.intrinsicContentSize.height
            self.contentSizeHieght.constant = 1000 + height
    }else if sender.tag == 1 {
            reviewsBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            detailsBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            descriptionBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            descriptionStack.isHidden = false
            detailsStack.isHidden = true
            reviewsStack.isHidden = true
            contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let height = self.productdescription.intrinsicContentSize.height
        self.contentSizeHieght.constant = 500 + height
        
        }else{
            descriptionBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            detailsBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            reviewsBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            descriptionStack.isHidden = true
            detailsStack.isHidden = true
            reviewsStack.isHidden = false
            contentView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
            self.reviewsStackSizeHieght.constant = 500
            self.contentSizeHieght.constant = 900

        }
    }
    
    @IBAction func addReviewBtn(sender: UIButton) {
        let vc = AddReviewVC.instantiateFromNib()
        vc?.productId = self.productId 
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        if self.token == "" {
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
            return
        }else{
            self.productVM.showIndicator()
            if  self.isFavourite {
                self.editFavourite(productId:  self.productId, Type: false)
                self.favouritBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)
            }else{
                self.editFavourite(productId:  self.productId, Type: true)
                self.favouritBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
              }
        }
    }
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        if self.token == "" {
            displayMessage(title: "",message: "please login first".localized, status: .error, forController: self)
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
            return
        }else{
            if add {
                self.productVM.showIndicator()
                self.addToCart(productId : self.productId,quantity: self.counter)
            }else{
                self.productVM.showIndicator()
                self.removeCart(productId : self.productId,quantity: 0)
            }
        }
    }
    
    @IBAction func hideCartButton(sender: UIButton) {
        self.cartView.isHidden = true
        self.hideCartBtn.isHidden = true
    }
    

    
    @IBAction func plusAction(_ sender: UIButton) {
        if self.token == "" {
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
            return
        }else{
            self.counter = counter + 1
            self.CounterLbl.text = "\(self.counter)"
        }
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        if self.token == "" {
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
            return
        }else{
            if counter > 1{
                self.counter = counter - 1
                self.CounterLbl.text = "\(self.counter)"
            }
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        blackView.isHidden = true
    }
    

    @IBAction func viewCartAction(_ sender: UIButton) {
        let main = MyCartVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func shareBtn(sender: UIButton) {
         if self.token == "" {
            displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {appDelegate.window??.rootViewController = sb}
            return
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/product"
        let artistItem = URLQueryItem(name: "productId", value: "\(self.productId)")
        components.queryItems = [artistItem]
         guard  let linkParameter = components.url else {return}
         guard let sharing = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://mader.page.link")else {return}
        if let bundleID = Bundle.main.bundleIdentifier {sharing.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)}
        sharing.iOSParameters?.appStoreID = ""
        sharing.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharing.socialMetaTagParameters?.title = producttitle.text
        sharing.shorten{ (url , warnning , error) in
            guard let url  = url else {return}
            self.share(url: url)
        }
    }
    
    func share(url: URL)  {
       let textToShare = [url] as [Any]
       let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
       activityViewController.popoverPresentationController?.sourceView = self.view
      activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
     self.present(activityViewController, animated: true, completion: nil)
   }
    
}

extension ProductDetailsVC : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == addsCollectionView{
        return  self.showShimmer ? 5 : self.photos.count
        }else{
            return  self.showShimmer ? 5 : Products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == addsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AddsCell
        if !self.showShimmer {
            if let bannerUrl = URL(string:   self.photos[indexPath.row] ){
            cell.photo.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
          }
        }
        
        cell.showShimmer = showShimmer
        return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! LiveCellCVC
            if !self.showShimmer {
                cell.priceLbl.text = "USD \(self.Products[indexPath.row].price ?? 0.0)"
                cell.titleLabel.text = self.Products[indexPath.row].title ?? ""

                if let bannerUrl = URL(string:   self.Products[indexPath.row].imageURL ?? ""){
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
    
        if collectionView == relatedProductCollectionView{
            let vc = ProductDetailsVC.instantiateFromNib()
            vc!.productId = self.Products[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension ProductDetailsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat
        
        if collectionView == addsCollectionView {
            size = (collectionView.frame.size.width)
        }else{
             size = (collectionView.frame.size.width - space) / 1.4
        }
        return CGSize(width: size, height: (collectionView.frame.size.height))
    }
}

extension ProductDetailsVC : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        self.reviewTableView.register(UINib(nibName: self.cellIdentifier2, bundle: nil), forCellReuseIdentifier: self.cellIdentifier2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier2) as! ReviewCell
    cell.confic(name: (self.reviews[indexPath.row].author?.firstName ?? "") + " " + (self.reviews[indexPath.row].author?.lastName ?? "") ,
                    imageUrl: self.reviews[indexPath.row].author?.profilePicture ?? "" ,
                    address: self.reviews[indexPath.row].content ?? "" ,
                    comment: self.reviews[indexPath.row].content ?? "",
                    rate :  self.reviews[indexPath.row].rate ?? 0)
        return cell
    }
    
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
extension ProductDetailsVC {
    func getproductDetails(id : Int) {
        productVM.getTopProductDetails(id: id).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.productVM.dismissIndicator()
            self.showShimmer = false
            if let data = dataModel.data {
            self.photos = data.photos ?? []
            self.reviews = data.reviews ?? []
            self.reviewTableView.reloadData()
            self.addsCollectionView.reloadData()
            self.artistName.text = data.artist?.name ?? ""
            self.productPrice.text = "USD " + String(data.price ?? 0)
            self.producttitle.text = data.shortDescription?.html2String ?? ""
            self.productdescription.text = data.dataDescription?.html2String ?? ""
            var projectCat = [String]()
            for cat in data.categories ?? []{
                projectCat.append(cat.name ?? "")
            }
                
            self.tagseLbl.text = "Tags: " + (projectCat.joined(separator: ","))
                if data.type ?? "" == "digital"{
                    self.typeLbl.text = "Type: Digital product"
                    self.typeIcon.image = #imageLiteral(resourceName: "Group 546")
                }else{
                    self.typeIcon.image = #imageLiteral(resourceName: "Path 518")
                    self.typeLbl.text = "Type: Physical product"
                }
            self.deliveryLbl.text = "Delivery: " +  String(data.delivery ?? 0) + " " + "days"
            self.productName.text = data.title ?? ""
            self.isFavourite = data.isFavorite ?? false
            let height = self.producttitle.intrinsicContentSize.height
            self.contentSizeHieght.constant = 1000 + height
            self.photoCount.text = String(data.photos?.count ?? 0)
            self.Products = data.product ?? []
            if data.product?.count ?? 0 > 0 {
                self.relatedProductCollectionView.isHidden = false
            }else{
                self.relatedProductCollectionView.isHidden = true
            }
                
            if data.photos?.count ?? 0 > 0 {
                    self.photoIndex.text =  "1"
                }else{
                    self.photoIndex.text =  "0"
                }
                if data.isFavorite ?? false {
                    self.favouritBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
                }else{
                    self.favouritBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)
                  }
                if let bannerUrl = URL(string:   data.artist?.profilPicture ?? ""){
                    self.artistPhoto.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
              }
            }
       }, onError: { (error) in
        self.productVM.dismissIndicator()
       }).disposed(by: disposeBag)
    }
    
    
    func editFavourite(productId : Int,Type : Bool) {
        productVM.addToFavourite(productId: productId, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.productVM.dismissIndicator()
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)
           }
       }, onError: { (error) in
        self.productVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    func shareProject(productId : Int) {
        productVM.shareProduct(productId:  productId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.productVM.dismissIndicator()
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)
           }
       }, onError: { (error) in
        self.productVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    
    func addToCart(productId : Int,quantity :Int) {
        productVM.addToCart(id:  productId,quantity:quantity).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.getCart()
            self.productVM.dismissIndicator()
            self.blackView.isHidden = false
                self.add = false
                self.addToCartBtn.setTitle("Remove from cart", for: .normal)
                self.addToCartBtn.setImage(#imageLiteral(resourceName: "Component 36 – 1"), for: .normal)
                self.addToCartBtn.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9058823529, blue: 0.9568627451, alpha: 1)
                self.addToCartBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
           }else{
            self.productVM.dismissIndicator()
            displayMessage(title: "",message: dataModel.message ?? "", status: .error, forController: self)
           }
       }, onError: { (error) in
        self.productVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    
    func getCart() {
        productVM.getCart().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.productVM.dismissIndicator()
            self.cartCount.text = "\(dataModel.data?.cardProducts?.count ?? 0)"
           }
       }, onError: { (error) in
        self.productVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
func removeCart(productId : Int,quantity :Int) {
        productVM.updateCart(id:  productId,quantity:quantity).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.getCart()
            self.productVM.dismissIndicator()
            self.add = true
            self.addToCartBtn.setTitle("add to cart", for: .normal)
            self.addToCartBtn.setImage(#imageLiteral(resourceName: "Path 331"), for: .normal)
            self.addToCartBtn.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1)
            self.addToCartBtn.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
           }
       }, onError: { (error) in
        self.productVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    
}

extension ProductDetailsVC: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if let _ = scrollView as? UICollectionView {
        DispatchQueue.main.async {
            let visibleIndices = self.addsCollectionView.indexPathsForVisibleItems
            let nextIndex = visibleIndices[0].row + 1
            self.photoIndex.text =  "\(nextIndex)"
        }
    }
  }
}
