//
//  CategeoryCell.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit
import Kingfisher

class CategeoryCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catLbl: UILabel!

    var selectAction: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func selectedAction(_ sender: UIButton) {
        selectAction?()
    }
    
}
