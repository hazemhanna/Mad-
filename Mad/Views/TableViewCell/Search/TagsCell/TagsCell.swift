//
//  TagsCell.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//

import UIKit

class TagsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shimmerView : ShimmerView!
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
