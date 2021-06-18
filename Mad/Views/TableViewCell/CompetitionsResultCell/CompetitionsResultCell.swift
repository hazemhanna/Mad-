//
//  CompetitionsResultCell.swift
//  Mad
//
//  Created by MAC on 18/06/2021.
//

import UIKit

class CompetitionsResultCell: UITableViewCell {

    @IBOutlet weak var shimmerView : ShimmerView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showShimmer = false
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
