//
//  VideoArtistCell.swift
//  Mad
//
//  Created by MAC on 19/05/2021.
//

import UIKit

class VideoArtistCell: UITableViewCell {

    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var typeLbl : UILabel!
    @IBOutlet weak var artistImage : UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var shimmerView : ShimmerView!

    var editFavourite: (() -> Void)? = nil
    var isFavourite = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showShimmer = false
    }
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    
    func confic(titleL : String ,profilPicture: String,isFavourite: Bool,art: Bool,music: Bool,design: Bool){
        titleLbl.text = titleL
         if art{
           self.typeLbl.text =  "Art"
         }else if music {
            self.typeLbl.text =  "Music"
         }else if design {
            self.typeLbl.text = "Design"
         }
         if let url = URL(string:   profilPicture){
            self.artistImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
         }
        self.isFavourite = isFavourite
        if isFavourite{
            self.favouriteBtn.setImage(UIImage(named: "Group 155"), for: .normal)
        }else{
            self.favouriteBtn.setImage(UIImage(named: "Group 140"), for: .normal)

        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editFavouriteAction(_ sender: UIButton) {
        self.editFavourite?()
        if isFavourite{
            isFavourite = false
            self.favouriteBtn.setImage(UIImage(named: "Group 140"), for: .normal)
        }else{
            isFavourite = true
            self.favouriteBtn.setImage(UIImage(named: "Group 155"), for: .normal)
        }
    }
}
