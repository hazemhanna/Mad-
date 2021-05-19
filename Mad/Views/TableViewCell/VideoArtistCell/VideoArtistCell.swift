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

    override func awakeFromNib() {
        super.awakeFromNib()
        self.showShimmer = false
    }
    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    
    func confic(title : String ,profilPicture: String,isFavourite: Bool,art: Bool,music: Bool,design: Bool){
        titleLbl.text = title
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
        
        if isFavourite{
            self.favouriteBtn.backgroundColor = #colorLiteral(red: 0.5764705882, green: 0.6235294118, blue: 0.7137254902, alpha: 1)
        }else{
            self.favouriteBtn.backgroundColor = #colorLiteral(red: 0.9282042384, green: 0.2310142517, blue: 0.4267850518, alpha: 1)

        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editFavouriteAction(_ sender: UIButton) {
        self.editFavourite?()
    }
}
