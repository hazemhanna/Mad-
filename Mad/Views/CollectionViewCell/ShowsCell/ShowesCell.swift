//
//  ShowesCell.swift
//  Mad
//
//  Created by MAC on 08/04/2021.
//

import UIKit

class ShowesCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var likeLbl : UILabel!
    @IBOutlet weak var shareLbl : UILabel!
    @IBOutlet weak var bannerImage : UIImageView!
    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var favouriteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.showShimmer = false
    }

    
    var favourite: (() -> Void)? = nil
    var share: (() -> Void)? = nil
    var isFavourite  = false
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    func confic (title : String, time : String, like : Int, share : Int, imageUrl :String,isFavourite : Bool){
        titleLbl.text = title
        timeLbl.text = time
        likeLbl.text = "\(like)"
        shareLbl.text = "\(share)"
        if let bannerUrl = URL(string: imageUrl ){
           self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
       }
        self.isFavourite = isFavourite
        if isFavourite {
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)
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

