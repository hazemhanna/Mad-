//
//  SuggestedCell.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import UIKit

class SuggestedCell: UICollectionViewCell {

    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var favouriteBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showShimmer = false
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
}
