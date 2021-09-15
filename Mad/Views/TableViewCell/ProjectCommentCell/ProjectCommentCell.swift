//
//  ProjectCommentCell.swift
//  Mad
//
//  Created by MAC on 15/09/2021.
//

import UIKit

class ProjectCommentCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var commentLbl : UILabel!
    @IBOutlet weak var imageUrl  : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func confic(name  : String , imageUrl : String ,date : String,comment : String){
        nameLbl.text = name
        dateLbl.text = date
        commentLbl.text = comment

        if  let productUrl = URL(string: imageUrl){
            self.imageUrl.kf.setImage(with: productUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
