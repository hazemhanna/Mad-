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

class ProductDetailsVC: UIViewController {

    @IBOutlet weak var addsCollectionView: UICollectionView!
    @IBOutlet weak var relatedProductCollectionView: UICollectionView!

    @IBOutlet weak var photoCount: UILabel!
    @IBOutlet weak var photoIndex: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var producttitle: UITextView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favouritBtn: UIButton!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistPhoto: UIImageView!
    @IBOutlet weak var contentSizeHieght : NSLayoutConstraint!
    @IBOutlet weak var productMatrial: UILabel!
    @IBOutlet weak var cartCount: UILabel!

    var token = Helper.getAPIToken() ?? ""
    var productId = Int()
    var showShimmer: Bool = true
    var showShimmer2: Bool = true
    var isFavourite: Bool = false
    var counter = 1

    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    
    var photos = [String]()

    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
   private let CellIdentifier = "LiveCellCVC"
   private let cellIdentifier = "AddsCell"

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        productVM.showIndicator()
        getproductDetails(id: self.productId)
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
    
    @IBAction func shareAction(_ sender: UIButton) {
        if self.token == "" {
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
            return
        }else{
            self.shareProject(productId : self.productId)

        }
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
            self.cartCount.text = "\(self.counter)"
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
                self.cartCount.text = "\(self.counter)"
            
            }
        }
    }
    
}

extension ProductDetailsVC : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == addsCollectionView{
        return  self.showShimmer ? 5 : self.photos.count
        }else{
            return  self.showShimmer ? 5 : 4
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
            
            cell.showShimmer = showShimmer2
            return cell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showShimmer {
            return
        }
    }
}

extension ProductDetailsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat
        
        if collectionView == addsCollectionView {
            size = (collectionView.frame.size.width - space) / 1.1
        }else{
             size = (collectionView.frame.size.width - space) / 1.4
        }
        return CGSize(width: size, height: (collectionView.frame.size.height))

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
         
            self.addsCollectionView.reloadData()
            self.artistName.text = data.artist?.name ?? ""
            self.productPrice.text = "USD " + String(data.price ?? 0)
            self.producttitle.text = data.dataDescription ?? ""
            self.productMatrial.text = data.materials ?? ""
                
            self.productName.text = data.title ?? ""
            self.isFavourite = data.isFavorite ?? false
            let height = self.producttitle.intrinsicContentSize.height
            self.contentSizeHieght.constant = 600 + height                
            self.photoCount.text = String(data.photos?.count ?? 0)
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
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.productVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    
    
    func shareProject(productId : Int) {
        productVM.shareProduct(productId:  productId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.productVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
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
