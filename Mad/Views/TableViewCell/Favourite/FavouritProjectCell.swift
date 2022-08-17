//
//  FavouritProjectCell.swift
//  Mad
//
//  Created by MAC on 09/07/2021.
//

import UIKit

class FavouritProjectCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productmage: UIImageView!
    @IBOutlet weak var shimmerView : ShimmerView!
    
    var removeFavourite: (() -> Void)? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        showShimmer = false
    }

    func confic (name : String, price : String,image : String){
        NameLbl.text = name
        priceLbl.text = price
        if let productUrl = URL(string: image){
            self.productmage.kf.setImage(with: productUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    
    @IBAction func removeAction(_ sender: UIButton) {
        self.removeFavourite?()
    }
    
    
}
