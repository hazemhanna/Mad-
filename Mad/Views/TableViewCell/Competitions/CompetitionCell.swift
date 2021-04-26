//
//  CompetitionCell.swift
//  Mad
//
//  Created by MAC on 26/04/2021.
//

import UIKit

class CompetitionCell: UITableViewCell {
    @IBOutlet weak var shimmerView : ShimmerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showShimmer = false
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
