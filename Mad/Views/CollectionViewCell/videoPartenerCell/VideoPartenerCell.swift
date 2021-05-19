//
//  VideoPartenerCell.swift
//  Mad
//
//  Created by MAC on 19/05/2021.
//

import UIKit

class VideoPartenerCell: UICollectionViewCell {
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
