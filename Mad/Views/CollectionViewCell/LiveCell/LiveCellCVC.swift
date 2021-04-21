//
//  LiveCellCVC.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit

class LiveCellCVC: UICollectionViewCell {

    @IBOutlet weak var shimmerView : ShimmerView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
}
