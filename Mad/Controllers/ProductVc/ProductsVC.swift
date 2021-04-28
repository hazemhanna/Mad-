//
//  ProductVc.swift
//  Mad
//
//  Created by MAC on 07/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ProductsVC : UIViewController {
   
    @IBOutlet weak var addproductCollectionView: UICollectionView!
    @IBOutlet weak var  topPrpductCollectionView: UICollectionView!
    @IBOutlet weak var forYouCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    var parentVC : HomeVC?
    let cellIdentifier1 = "ProjectCell"
    let cellIdentifier2 = "ForYouCell"
    let cellIdentifier3 = "ArtistCell"

    var product = [Product]()
    var suggested = [Product]()
    var categeory = [Category]()
    
    var showShimmer1: Bool = true
    var showShimmer2: Bool = true
    var showShimmer3: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNib()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCategory()
        getSuggested()
        getAllproduct(pageNum : 1)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
    
   }
    
}
extension ProductsVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == addproductCollectionView {
        return  self.showShimmer1 ? 5 : categeory.count + 1
        }else if collectionView == topPrpductCollectionView{
            return  self.showShimmer2 ? 5 : suggested.count
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
        if indexPath.row == 0 {
                cell.catImage.isHidden = true
                cell.addProjectBtn.isHidden = false
                cell.projectNameLabel.text = "Add Product"
            }else{
                cell.catImage.isHidden = false
                cell.addProjectBtn.isHidden = true
                cell.projectNameLabel.text = self.categeory[indexPath.row-1].name ?? ""
                if let url = URL(string:   self.categeory[indexPath.row-1].imageURL ?? ""){
                cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Icon - Checkbox - Off"))
                }
            }
            cell.add = {
                let vc = AddProductImageVc.instantiateFromNib()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        cell.showShimmer = showShimmer1
        return cell
        
      }else if collectionView == topPrpductCollectionView {
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
            if indexPath.row == 0 {
                let vc = AddProductImageVc.instantiateFromNib()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
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
             self.forYouCollectionView.reloadData()
            self.topPrpductCollectionView.reloadData()

           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    func getAllproduct(pageNum : Int) {
        productVM.getAllProduct(pageNum : pageNum).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer3 = false
            self.product = dataModel.data?.products ?? []
            self.productCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }

}
