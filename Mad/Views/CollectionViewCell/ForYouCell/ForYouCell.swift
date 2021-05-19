//
//  ForYouCell.swift
//  Mad
//
//  Created by MAC on 07/04/2021.
//

import UIKit

class ForYouCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var priceLbl: UILabel!

    
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
