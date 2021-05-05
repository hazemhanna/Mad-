//
//  AddsCell.swift
//  Mad
//
//  Created by MAC on 03/05/2021.
//

import UIKit

class AddsCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!
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
