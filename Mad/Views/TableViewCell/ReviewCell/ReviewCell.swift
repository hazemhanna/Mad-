//
//  ReviewCell.swift
//  Mad
//
//  Created by MAC on 09/07/2021.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl : UILabel!
    @IBOutlet weak var commentLbl : UILabel!
    @IBOutlet weak var imageUrl  : UIImageView!
    @IBOutlet weak var rateView   : CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rateView.isUserInteractionEnabled = false
    }

    func confic(name  : String , imageUrl : String ,address : String,comment : String,rate : Int){
        nameLbl.text = name
        addressLbl.text = address
        commentLbl.text = comment
        rateView.rating = Double(rate)
        if  let productUrl = URL(string: imageUrl){
            self.imageUrl.kf.setImage(with: productUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
