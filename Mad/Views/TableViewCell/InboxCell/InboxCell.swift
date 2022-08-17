//
//  InboxCell.swift
//  Mad
//
//  Created by MAC on 08/07/2021.
//

import UIKit

class InboxCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var shimmerView : ShimmerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        showShimmer = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func confic(name : String , artistUrl : String ,content : String){
        NameLbl.text = name
        contentLbl.text = content
        if  let productUrl = URL(string: artistUrl){
            self.artistImage.kf.setImage(with: productUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
    }
    
 
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
}
