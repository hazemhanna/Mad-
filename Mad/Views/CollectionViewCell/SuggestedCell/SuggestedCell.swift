//
//  SuggestedCell.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import UIKit

class SuggestedCell: UICollectionViewCell {

    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var shimmerView : ShimmerView!
    @IBOutlet weak var favouriteBtn: UIButton!

    var editFavourite : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.showShimmer = false
    }
    
    func confic(name : String , bannerImg : String,profilPicture: String,isFavourite: Bool,art: Bool,music: Bool,design: Bool){
        self.artistNameLabel.text = name
         if art{
           self.typeLabel.text =  "#Art"
         }else if music {
            self.typeLabel.text =  "#Music"
         }else if design {
            self.typeLabel.text = "#Design"
         }
         if let url = URL(string:   profilPicture){
            self.profileImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
         }
         if let bannerUrl = URL(string: bannerImg ){
            self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
        if isFavourite{
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Path 326-1"), for: .normal)
        }
    }
    
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    @IBAction func editFavouriteAction(_ sender: UIButton) {
        self.editFavourite?()
    }
    
}
