//
//  ProductVc.swift
//  Mad
//
//  Created by MAC on 07/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import StagLayout


class ProductsVC : UIViewController {
   
    @IBOutlet weak var addproductCollectionView: UICollectionView!
    @IBOutlet weak var  topPrpductCollectionView: UICollectionView!
    @IBOutlet weak var forYouCollectionView: UICollectionView!
    @IBOutlet weak var  productView: UIView!
    @IBOutlet weak var  forYouView: UIView!
    @IBOutlet weak var suggestedTitle: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var topProductTitle: UILabel!
    
    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    var parentVC : HomeVC?
    let cellIdentifier1 = "ProjectCell"
    let cellIdentifier2 = "ForYouCell"
    let cellIdentifier3 = "ArtistCell"

    var product = [Product]()
    var suggested = [Product]()
    var TopProduct = [Product]()
    var categeory = [Category]()
    var token = Helper.getAPIToken() ?? ""
    var type = Helper.getType() ?? false
    var active = Helper.getIsActive() ?? false
    var showShimmer1: Bool = true
    var showShimmer2: Bool = true
    var showShimmer3: Bool = true
    var showShimmer4: Bool = true
    var selectedIndex = -1
    var catId = Int()
    var selectTwice = false
    var page = 1
    var isFatching = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNib()
        if token != "" {
            self.forYouView.isHidden = false
        }else{
            self.forYouView.isHidden = true
        }
        
        suggestedTitle.text = "sugessted".localized
        productTitle.text = "Product".localized
        topProductTitle.text = "topProduct".localized
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCategory()
        getSuggested()
        getAllproduct(pageNum : 1)
        getTopproduct(CategoryId : 36,pageNum : 1)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        productView.addSubview(productCollectionView)
        productCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productCollectionView.leadingAnchor.constraint(equalTo: productView.leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: productView.trailingAnchor),
            productCollectionView.topAnchor.constraint(equalTo: productView.topAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: productView.bottomAnchor)
        ])
    }
    
    
   func setupNib(){
    self.addproductCollectionView.register(UINib(nibName: cellIdentifier1, bundle: nil), forCellWithReuseIdentifier: cellIdentifier1)
    addproductCollectionView.delegate = self
    addproductCollectionView.dataSource = self
    self.topPrpductCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
    topPrpductCollectionView.delegate = self
    topPrpductCollectionView.dataSource = self
    self.forYouCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
    forYouCollectionView.delegate = self
    forYouCollectionView.dataSource = self
    self.productCollectionView.register(UINib(nibName: cellIdentifier3, bundle: nil), forCellWithReuseIdentifier: cellIdentifier3)
    productCollectionView.delegate = self
    productCollectionView.dataSource = self
    productCollectionView.prefetchDataSource = self
    productCollectionView.isPrefetchingEnabled = true
   }
    
    private let productCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: StagLayout(widthHeightRatios: [(0.5, 0.5), (0.5, 1.5), (0.5, 1.0),(1.0, 1.0)], itemSpacing: 4)
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
}
extension ProductsVC: UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == addproductCollectionView {
            if active {
                return  self.showShimmer1 ? 5 : categeory.count + 1
            }else{
                return  self.showShimmer1 ? 5 : categeory.count
            }
        }else if collectionView == topPrpductCollectionView{
            return  self.showShimmer4 ? 5 : TopProduct.count
        }else if collectionView == forYouCollectionView{
            return  self.showShimmer2 ? 5 : suggested.count
        }else{
            return  self.showShimmer3 ? 5 : product.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      if collectionView == addproductCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier1, for: indexPath) as! ProjectCell
      
        if !self.showShimmer1 {
            if active {
               if indexPath.row == 0 {
                    cell.catImage.isHidden = true
                    cell.addProjectBtn.isHidden = false
                cell.projectNameLabel.text = "Add.Product".localized
                 }else{
                     cell.catImage.isHidden = false
                    cell.addProjectBtn.isHidden = true
                    cell.projectNameLabel.text = self.categeory[indexPath.row-1].name ?? ""
                    if let url = URL(string:   self.categeory[indexPath.row-1].imageURL ?? ""){
                    cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Icon - Checkbox - Off"))
                    }
                }
                }else{
                    cell.catImage.isHidden = false
                    cell.addProjectBtn.isHidden = true
                    cell.projectNameLabel.text = self.categeory[indexPath.row].name ?? ""
                    if let url = URL(string:   self.categeory[indexPath.row].imageURL ?? ""){
                    cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Icon - Checkbox - Off"))
                    }
                }
            cell.add = {
                if self.token != "" {
                let vc = AddProductImageVc.instantiateFromNib()
                self.navigationController?.pushViewController(vc!, animated: true)
                }
                else{
                    displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
                    let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                    if let appDelegate = UIApplication.shared.delegate {
                        appDelegate.window??.rootViewController = sb
                    }
                    return
                }
            }
            
            if self.selectedIndex == indexPath.row{
                if self.selectTwice {
                    cell.ProjectView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1).cgColor
                    cell.ProjectView.layer.borderWidth = 0
                }else{
                    cell.ProjectView.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1).cgColor
                    cell.ProjectView.layer.borderWidth = 2
                }
            }else {
                cell.ProjectView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1).cgColor
                cell.ProjectView.layer.borderWidth = 0
               }
            
        }
        cell.showShimmer = showShimmer1
        return cell
        
      }else if collectionView == topPrpductCollectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! ForYouCell
        
        if !self.showShimmer4 {
            cell.artistNameLabel.text = self.TopProduct[indexPath.row].artist?.name ?? ""
            cell.priceLbl.text = "USD \(self.TopProduct[indexPath.row].price ?? 0.0)"
            cell.titleLabel.text = self.TopProduct[indexPath.row].title ?? ""
            if let url = URL(string:   self.TopProduct[indexPath.row].artist?.profilPicture ?? ""){
                cell.profileImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
            }
            if let bannerUrl = URL(string:   self.TopProduct[indexPath.row].imageURL ?? ""){
            cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
         }
         cell.showShimmer = showShimmer4
        return cell
        
        }else if collectionView == forYouCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! ForYouCell
            if !self.showShimmer2 {
                cell.artistNameLabel.text = self.suggested[indexPath.row].artist?.name ?? ""
                cell.priceLbl.text = "USD \(self.suggested[indexPath.row].price ?? 0.0)"
                cell.titleLabel.text = self.suggested[indexPath.row].title ?? ""
                if let url = URL(string:   self.suggested[indexPath.row].artist?.profilPicture ?? ""){
                    cell.profileImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
                }
                if let bannerUrl = URL(string:   self.suggested[indexPath.row].imageURL ?? ""){
                cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
             }
             cell.showShimmer = showShimmer2
            return cell
        }else{
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier3, for: indexPath) as! ArtistCell
            if !self.showShimmer3 {
                cell.artistNameLabel.text = self.product[indexPath.row].title ?? ""
                cell.favouriteCount.text = "\(self.product[indexPath.row].favoriteCount ?? 0)"
                cell.followerCount.text = "\(self.product[indexPath.row].shareCount ?? 0)"
                if let bannerUrl = URL(string:   self.product[indexPath.row].imageURL ?? ""){
                cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
             }
             cell.showShimmer = showShimmer3
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == addproductCollectionView {
            if active {
            if indexPath.row != 0 {
                if  self.selectedIndex == indexPath.row {
                    self.selectedIndex = indexPath.row
                    self.addproductCollectionView.reloadData()
                    self.showShimmer3 = true
                    self.showShimmer4 = true
                    self.topPrpductCollectionView.reloadData()
                    self.productCollectionView.reloadData()
                    self.selectTwice = true
                    getAllproduct(pageNum : 1)
                    getTopproduct(CategoryId : 36,pageNum : 1)
                }else{
                    self.selectedIndex = indexPath.row
                    self.addproductCollectionView.reloadData()
                    self.selectTwice = false
                    self.showShimmer3 = true
                    self.showShimmer4 = true
                    self.topPrpductCollectionView.reloadData()
                    self.productCollectionView.reloadData()
                    getAllproductWithCat(pageNum : 1, catId: self.categeory[indexPath.row - 1].id ?? 0)
                    getTopproduct(CategoryId : self.categeory[indexPath.row - 1].id ?? 0,pageNum : 1)
                }
            }
            }else{
                if self.selectedIndex == indexPath.row {
                    self.selectedIndex = indexPath.row
                    self.addproductCollectionView.reloadData()
                    self.selectTwice = true
                    self.showShimmer3 = true
                    self.showShimmer4 = true
                    self.topPrpductCollectionView.reloadData()
                    self.productCollectionView.reloadData()
                    getAllproduct(pageNum : 1)
                    getTopproduct(CategoryId : 36,pageNum : 1)
                }else{
                    self.selectedIndex = indexPath.row
                    self.addproductCollectionView.reloadData()
                    self.selectTwice = false
                    self.showShimmer3 = true
                    self.showShimmer4 = true
                    self.topPrpductCollectionView.reloadData()
                    self.productCollectionView.reloadData()
                    getAllproductWithCat(pageNum : 1, catId: self.categeory[indexPath.row].id ?? 0)
                    getTopproduct(CategoryId : self.categeory[indexPath.row].id ?? 0,pageNum : 1)
                }
            }
        }else if  collectionView == topPrpductCollectionView{
            let vc = ProductDetailsVC.instantiateFromNib()
            vc!.productId = self.TopProduct[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if  collectionView == forYouCollectionView{
            let vc = ProductDetailsVC.instantiateFromNib()
            vc!.productId = self.suggested[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if  collectionView == productCollectionView{
            let vc = ProductDetailsVC.instantiateFromNib()
            vc!.productId = self.product[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= (product.count) - 4  && isFatching{
                self.productVM.showIndicator()
                getAllproduct(pageNum: self.page)
                isFatching = false
                break
            }
        }
      }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= (product.count) - 4  && isFatching{
            getAllproduct(pageNum: self.page)
            isFatching = false
        }
    }
}

extension ProductsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == addproductCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: collectionView.frame.size.height)
        
        }else if collectionView == topPrpductCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 2.5
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else if collectionView == forYouCollectionView {

            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 2.2
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else{
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let width : CGFloat = (collectionView.frame.size.width - space) / 3.5
            let height : CGFloat  = 140
            
            return CGSize(width: width, height: height)
        }
    }
}

extension ProductsVC {
    func getCategory() {
        productVM.getCategories().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer1 = false
               self.categeory = dataModel.data ?? []
            self.addproductCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    func getSuggested() {
        productVM.getSuggested().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer2 = false
            self.suggested = dataModel.data ?? []
            if self.suggested.count > 0 {
                self.forYouView.isHidden = false
            }else{
                self.forYouView.isHidden = true
            }
            self.forYouCollectionView.reloadData()

           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    func getAllproduct(pageNum : Int) {
        productVM.getAllProduct(pageNum : pageNum).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer3 = false
            self.productVM.dismissIndicator()
            self.product.append(contentsOf: dataModel.data?.data ?? [])
            self.productCollectionView.reloadData()
            if  self.page < dataModel.data?.countPages ?? 0 && !self.isFatching{
                self.isFatching = true
                self.page += 1
            }
           }
       }, onError: { (error) in
        self.productVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    func getAllproductWithCat(pageNum : Int,catId:Int) {
        productVM.getAllProductWithCat(pageNum : pageNum,catId : catId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer3 = false
            self.product = dataModel.data?.data ?? []
            self.productCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    func getTopproduct(CategoryId : Int,pageNum : Int) {
        productVM.getTopProduct(id : CategoryId,pageNum : pageNum).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer4 = false
            self.TopProduct = dataModel.data?.data ?? []
            self.topPrpductCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
}
