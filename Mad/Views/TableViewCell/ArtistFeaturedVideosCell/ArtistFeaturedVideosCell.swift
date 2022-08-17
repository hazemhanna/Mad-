//
//  ArtistFeaturedVideosCell.swift
//  Mad
//
//  Created by MAC on 26/02/2022.
//

import UIKit

class ArtistFeaturedVideosCell: UITableViewCell {

    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var bannerImage : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var openDetails: (() -> Void)? = nil
    var openVideo: (() -> Void)? = nil
    
    func confic (title : String, time : String,imageUrl :String){
        titleLbl.text = title
        timeLbl.text = time
        if let bannerUrl = URL(string: imageUrl ){
           self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
       }
    
    }
    
    @IBAction func openDetailsAction(_ sender: UIButton) {
        self.openDetails?()
    }
    @IBAction func openvideoAction(_ sender: UIButton) {
        self.openVideo?()
    }

}
