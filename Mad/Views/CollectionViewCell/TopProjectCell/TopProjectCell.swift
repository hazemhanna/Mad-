//
//  TopProjectCell.swift
//  Mad
//
//  Created by MAC on 14/09/2021.
//



import UIKit

class TopProjectCell : UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var editBtn : UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        showShimmer = false
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
}
