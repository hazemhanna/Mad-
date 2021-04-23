//
//  LiveCellCVC.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit

class LiveCellCVC: UICollectionViewCell {

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
