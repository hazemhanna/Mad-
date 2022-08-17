//
//  ArtistProductsVc.swift
//  Mad
//
//  Created by MAC on 23/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ArtistProductsVc: UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var availableLbl : UILabel!

    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var token = Helper.getAPIToken() ?? ""

    var artistId = Helper.getArtistId() ?? 0
    let cellIdentifier = "ProductCell"
    var products = [Product]()
     var showShimmer = true
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getArtistProfile(artistId : artistId)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
}


extension ArtistProductsVc :  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 3 : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProductCell
        if !self.showShimmer {
            cell.priceLbl.text = "USD \(self.products[indexPath.row].price ?? 0.0)"
            cell.titleLabel.text = self.products[indexPath.row].title ?? ""
         
            if let bannerUrl = URL(string:   self.products[indexPath.row].imageURL ?? ""){
            cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
      
            if self.products[indexPath.row].isFavorite ?? false {
               cell.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
            }else{
               cell.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)
            }
            
            cell.favourite = {
                if self.token == "" {
                    let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                    if let appDelegate = UIApplication.shared.delegate {
                        appDelegate.window??.rootViewController = sb
                    }
                    return
                }else{
                    self.artistVM.showIndicator()
                    if self.products[indexPath.row].isFavorite ?? false{
                        self.editFavourite(productId:   self.products[indexPath.row].id ?? 0  , Type: false)
                      //  cell.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)
                    }else{
                        self.editFavourite(productId:  self.products[indexPath.row].id ?? 0, Type: true)
                       // cell.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
                      }
                }
            }
        }
         cell.showShimmer = showShimmer
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailsVC.instantiateFromNib()
        vc!.productId = self.products[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ArtistProductsVc : UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    
        let size:CGFloat = (collectionView.frame.size.width - space ) / 2.1
        
            return CGSize(width: size, height: 220)
        }
    
}

extension ArtistProductsVc  {
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.products = dataModel.data?.products ?? []
            self.productCollectionView.reloadData()

            if dataModel.data?.products?.count ?? 0  > 0 {
                self.productCollectionView.isHidden = false
                self.availableLbl.isHidden = true

            }else{
                self.productCollectionView.isHidden = true
                self.availableLbl.isHidden = false
            }
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    
    
    func editFavourite(productId : Int,Type : Bool) {
        artistVM.addToFavouriteProduct(productId: productId, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)
               self.getArtistProfile(artistId : self.artistId)
               self.productCollectionView.reloadData()
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    
}
