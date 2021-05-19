//
//  VideoPurchaseVc.swift
//  Mad
//
//  Created by MAC on 19/05/2021.
//

import UIKit

class VideoPurchaseVc: UIViewController {

    @IBOutlet weak var PurchaseCollectionView: UICollectionView!

    let cellIdentifier = "ForYouCell"
    var showShimmer: Bool = true
    var parentVC : VideoDetailsVc?

    var product = [Product](){
        didSet{
            self.PurchaseCollectionView.reloadData()
            showShimmer = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.PurchaseCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        PurchaseCollectionView.delegate = self
        PurchaseCollectionView.dataSource = self
    }

}

extension VideoPurchaseVc: UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 2 : product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ForYouCell
        
        if !self.showShimmer{
            cell.mainView.backgroundColor = .black
            cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
            cell.mainView.layer.borderWidth = 0.5
            cell.artistNameLabel.textColor = .white
            cell.priceLbl.textColor = .white
            cell.titleLabel.textColor = .white
            
            cell.artistNameLabel.text = self.product[indexPath.row].artist?.name ?? ""
            cell.priceLbl.text = "USD \(self.product[indexPath.row].price ?? 0.0)"
            cell.titleLabel.text = self.product[indexPath.row].title ?? ""
            if let url = URL(string:   self.product[indexPath.row].artist?.profilPicture ?? ""){
                cell.profileImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
                }
            if let bannerUrl = URL(string:   self.product[indexPath.row].imageURL ?? ""){
              cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
              }
        }
        cell.showShimmer = showShimmer
        return cell
      }

    }

extension VideoPurchaseVc: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2
        return CGSize(width: size, height: 240)
        }
}
