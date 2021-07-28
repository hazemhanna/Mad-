//
//  FavouritProjectCell.swift
//  Mad
//
//  Created by MAC on 09/07/2021.
//

import UIKit

class FavouritProjectCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productmage: UIImageView!
    @IBOutlet weak var shimmerView : ShimmerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showShimmer = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
}