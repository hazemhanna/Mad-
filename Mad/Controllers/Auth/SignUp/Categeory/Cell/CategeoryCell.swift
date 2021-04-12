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
    func confic(imageURL : String , name : String){
        guard let url = URL(string:  imageURL) else  { return }
        self.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        catLbl.text = name ?? ""
    }
    
    @IBAction func selectedAction(_ sender: UIButton) {
        selectAction?()
    }
    
}
