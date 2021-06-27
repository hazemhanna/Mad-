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

    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artistId = Helper.getArtistId() ?? 0
    let cellIdentifier = "LiveCellCVC"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LiveCellCVC
        if !self.showShimmer {
            cell.priceLbl.text = "USD \(self.products[indexPath.row].price ?? 0.0)"
            cell.titleLabel.text = self.products[indexPath.row].title ?? ""
         
            if let bannerUrl = URL(string:   self.products[indexPath.row].imageURL ?? ""){
            cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
            cell.editBtn.isHidden = false
        }
         cell.showShimmer = showShimmer
        cell.editBtn.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
}
extension ArtistProductsVc : UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    
        let size:CGFloat = (collectionView.frame.size.width - space) - 32
            return CGSize(width: size, height: 140)
        }
    
}


extension ArtistProductsVc  {
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.products = dataModel.data?.products ?? []
            self.productCollectionView.reloadData()
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
