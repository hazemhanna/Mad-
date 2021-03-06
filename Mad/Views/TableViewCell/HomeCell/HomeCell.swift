//
//  HomeCell.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var liveCollectionViewHieht: NSLayoutConstraint!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var LikeLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var trustImage: UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favouriteStack : UIStackView!
    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var artistStack : UIStackView!

    var deleget : ProjectsVC?
    var favourite: (() -> Void)? = nil
    var share: (() -> Void)? = nil
    
    let cellIdentifier = "LiveCellCVC"
    var product  = [Product]()
    var isFavourite  = false
    override func awakeFromNib() {
        super.awakeFromNib()

        self.liveCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self
        self.showShimmer = false
    }
    
    
    func confic (name : String,date : String, title : String , like :Int , share : Int, profileUrl : String , projectUrl :String , trustUrl : String,isFavourite : Bool,relatedProduct : [Product]){
        
         NameLbl.text = name
         dateLbl.text = date
         titleLbl.text = title
         LikeLbl.text = "\(like)"
         shareLbl.text = "\(share)"
        self.product = relatedProduct
        liveCollectionView.reloadData()
        if relatedProduct.count > 0{
            liveCollectionViewHieht.constant = 100
            liveView.isHidden = false
        }else{
            liveCollectionViewHieht.constant = 1
            liveView.isHidden = true
        }
        
        if let profileImageUrl = URL(string: profileUrl){
        self.profileImage.kf.setImage(with: profileImageUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
        if  let projectUrl = URL(string: projectUrl){
        self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
        if let trustUrl = URL(string: trustUrl){
        self.trustImage.kf.setImage(with: trustUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
        self.isFavourite = isFavourite
        if isFavourite {
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)

        }
    }
    
    
    
    
    func confic (name : String,date : String,title : String , share : Int , projectUrl :String,relatedProduct : [Product]){
        
        NameLbl.text = name
        NameLbl.numberOfLines = 2
        dateLbl.text = date
        titleLbl.text = title
        titleLbl.numberOfLines = 2
        shareLbl.text = "\(share)"
        self.product = relatedProduct
        liveCollectionView.reloadData()
        if relatedProduct.count > 0{
            liveCollectionViewHieht.constant = 100
            liveView.isHidden = false
        }else{
            liveCollectionViewHieht.constant = 1
            liveView.isHidden = true
        }
        if let projectUrl = URL(string: projectUrl){
        self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        self.favourite?()
        if self.isFavourite {
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)
        }

    }
    
    
    @IBAction func shareAction(_ sender: UIButton) {
        self.share?()
    }
    
}

extension HomeCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 3 : product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailsVC.instantiateFromNib()
        vc!.productId = self.product[indexPath.row].id ?? 0
        self.deleget?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    
        let size:CGFloat = (collectionView.frame.size.width - space) / 1.4
            return CGSize(width: size, height: (collectionView.frame.size.height))
        }

    
}
