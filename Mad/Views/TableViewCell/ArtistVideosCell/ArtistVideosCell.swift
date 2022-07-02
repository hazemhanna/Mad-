//
//  ArtistVideosCell.swift
//  Mad
//
//  Created by MAC on 26/02/2022.
//

import UIKit

class ArtistVideosCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var likeLbl : UILabel!
    @IBOutlet weak var shareLbl : UILabel!
    @IBOutlet weak var bannerImage : UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var detailsBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    var openDetails: (() -> Void)? = nil
    var openVideo: (() -> Void)? = nil

    var favourite: (() -> Void)? = nil
    var share: (() -> Void)? = nil
    var isFavourite  = false
    
 
    func confic (title : String, time : String, like : Int, share : Int, imageUrl :String,isFavourite : Bool){
        titleLbl.text = title
        timeLbl.text = time
        likeLbl.text = "\(like)"
        shareLbl.text = "\(share)"
        if let bannerUrl = URL(string: imageUrl ){
           self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
       }
        self.isFavourite = isFavourite
        if isFavourite {
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Path 326"), for: .normal)
        }
    }
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        self.favourite?()
        if self.isFavourite {
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Path 326"), for: .normal)
        }

    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        self.share?()
    }

    
    @IBAction func openDetailsAction(_ sender: UIButton) {
        self.openDetails?()
    }
    
    @IBAction func openvideoAction(_ sender: UIButton) {
        self.openVideo?()
    }

}
