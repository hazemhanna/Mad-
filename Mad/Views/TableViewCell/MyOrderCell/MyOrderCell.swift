//
//  MyOrderCell.swift
//  Mad
//
//  Created by MAC on 06/07/2021.
//

import UIKit

class MyOrderCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productmage: UIImageView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var orderNumLbl: UILabel!

    @IBOutlet weak var shimmerView : ShimmerView!

    var details : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        showShimmer = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func confic(name : String , productUrl : String , price : String , orderNum : String , artistName : String , artistUrl : String){
        NameLbl.text = name
        priceLbl.text = name
        artistNameLbl.text = artistName
        orderNumLbl.text = "Order #" + orderNum
        if  let artistUrl = URL(string: artistUrl){
            self.artistImage.kf.setImage(with: artistUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
        
        if  let productUrl = URL(string: productUrl){
            self.productmage.kf.setImage(with: productUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
    }
    
    @IBAction func detailsAction(_ sender: UIButton) {
        self.details?()
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }

    
}
