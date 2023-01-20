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
    @IBOutlet weak var deleteBtn: UIButton!

    var addPhoto : (() -> Void)? = nil
    var deletePhoto : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func addPhotoAction(_ sender: UIButton) {
        self.addPhoto?()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.deletePhoto?()
    }
}
