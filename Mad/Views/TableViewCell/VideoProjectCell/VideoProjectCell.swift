//
//  VideoProjectCell.swift
//  Mad
//
//  Created by MAC on 19/05/2021.
//

import UIKit

class VideoProjectCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var LikeLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var shimmerView : ShimmerView!
    
    var favourite: (() -> Void)? = nil
    var share: (() -> Void)? = nil
    var isFavourite  = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.showShimmer = false
    }

    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }
    
    func confic ( title : String , like :Int , share : Int, projectUrl :String,isFavourite : Bool){
        
         titleLbl.text = title
         LikeLbl.text = "\(like)"
         shareLbl.text = "\(share)"
        
        if  let projectUrl = URL(string: projectUrl){
        self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
      
        self.isFavourite = isFavourite
        if isFavourite {
           self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
            self.favouriteBtn.setImage(#imageLiteral(resourceName: "Path 326"), for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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
    
}
