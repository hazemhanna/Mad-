//
//  SocialCell.swift
//  Mad
//
//  Created by MAC on 25/05/2021.
//

import UIKit

class SocialCell: UITableViewCell {

    @IBOutlet weak var  nameLbl: UILabel!
    @IBOutlet weak var  iconImage: UIImageView!
    var details: (() -> Void)? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func confic(name : String,icon : String){
        nameLbl.text = name
        if let iconURl = URL(string: icon){
        self.iconImage.kf.setImage(with: iconURl, placeholder: #imageLiteral(resourceName: "Group 350"))
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func detailsAction(_ sender: UIButton) {
        self.details?()
    }
    
    
}
