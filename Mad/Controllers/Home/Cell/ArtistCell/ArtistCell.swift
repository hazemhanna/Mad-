//
//  ArtistCell.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import UIKit

class ArtistCell: UICollectionViewCell {
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var favouriteCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var shimmerView : ShimmerView!
    
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
