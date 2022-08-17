//
//  SearchItemsCell.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//

import UIKit

class SearchItemsCell: UITableViewCell {

    @IBOutlet weak var bannermage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var artistStack: UIStackView!
    @IBOutlet weak var activeStack: UIStackView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistNmaeLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeIcon: UIView!
    var remove : (() -> Void)? = nil

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
    
    
    
    @IBAction func removeAction(_ sender: UIButton) {
        self.remove?()
    }
}
