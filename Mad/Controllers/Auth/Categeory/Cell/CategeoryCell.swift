//
//  CategeoryCell.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit

class CategeoryCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    var selectAction: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func selectedAction(_ sender: UIButton) {
        selectAction?()
    }
    
}
