//
//  SearchArtistCell.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//

import UIKit

class SearchArtistCell: UITableViewCell {

    @IBOutlet weak var bannermage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
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
