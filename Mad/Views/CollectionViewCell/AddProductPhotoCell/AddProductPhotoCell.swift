//
//  AddProductPhotoCell.swift
//  Mad
//
//  Created by MAC on 27/04/2021.
//

import UIKit

class AddProductPhotoCell: UICollectionViewCell {

    @IBOutlet weak var ProducttView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    var addPhoto : (() -> Void)? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func addPhotoAction(_ sender: UIButton) {
        self.addPhoto?()
    }
    
}
