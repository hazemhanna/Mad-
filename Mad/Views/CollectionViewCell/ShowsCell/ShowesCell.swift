//
//  ShowesCell.swift
//  Mad
//
//  Created by MAC on 08/04/2021.
//

import UIKit

class ShowesCell: UICollectionViewCell {
    
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
