//
//  CompetitionsResultCell.swift
//  Mad
//
//  Created by MAC on 18/06/2021.
//

import UIKit

class CompetitionsResultCell: UITableViewCell {

    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var bannerImage : UIImageView!
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var voteBtn : UIButton!

    var vote: (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showShimmer = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func confic (name : String,profileUrl : String , bannerUrl :String ,isVote : Bool){
        
        nameLbl.text = name
        if isVote {
            self.voteBtn.isHidden = true
        }else{
            self.voteBtn.isHidden = false
        }
        if let profileImageUrl = URL(string: profileUrl){
        self.profileImage.kf.setImage(with: profileImageUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
        if  let projectUrl = URL(string: bannerUrl){
        self.bannerImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    
    @IBAction func voteBtn(_ sender: UIButton) {
        self.vote?()
    }
    
}
