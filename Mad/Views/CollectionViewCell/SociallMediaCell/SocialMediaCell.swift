//
//  SocialMediaCell.swift
//  Mad
//
//  Created by MAC on 15/11/2021.
//

import UIKit

class SocialMediaCell: UICollectionViewCell {

    @IBOutlet weak var  nameLbl: UILabel!
    @IBOutlet weak var  iconImage: UIImageView!
    var details: (() -> Void)? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func confic(name : String,icon : String){
        if let iconURl = URL(string: icon){
        self.iconImage.kf.setImage(with: iconURl, placeholder: #imageLiteral(resourceName: "Group 350"))
        }
        
    }
  
    @IBAction func detailsAction(_ sender: UIButton) {
        self.details?()
    }
    

}
