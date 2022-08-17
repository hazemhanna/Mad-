//
//  ProductCell.swift
//  Mad
//
//  Created by MAC on 25/02/2022.
//

import UIKit

import UIKit

class ProductCell : UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var favouriteBtn  : UIButton!

    var favourite: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        showShimmer = false
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        self.favourite?()
    }

    
}
