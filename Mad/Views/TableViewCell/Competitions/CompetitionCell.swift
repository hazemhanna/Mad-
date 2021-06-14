//
//  CompetitionCell.swift
//  Mad
//
//  Created by MAC on 26/04/2021.
//

import UIKit

class CompetitionCell: UITableViewCell {
   
    @IBOutlet weak var bannermage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shimmerView : ShimmerView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showShimmer = false
    }
    
    func confic(imageUrl :String,title : String , date : String ){
        
        dateLbl.text = date
        titleLabel.text = title
        if let url = URL(string: imageUrl){
            self.bannermage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
        
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
