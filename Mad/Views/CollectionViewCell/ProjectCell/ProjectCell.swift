//
//  ProjectCell.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit

class ProjectCell: UICollectionViewCell {
    
    @IBOutlet weak var ProjectView: UIView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var addProjectBtn: UIButton!

    var add : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.projectNameLabel.adjustsFontSizeToFitWidth = true
        self.projectNameLabel.minimumScaleFactor = 0.5
        self.projectNameLabel.numberOfLines = 1

        self.showShimmer = false
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        self.add?()
    }
    
}
