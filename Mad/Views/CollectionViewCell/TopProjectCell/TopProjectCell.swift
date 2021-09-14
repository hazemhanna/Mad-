//
//  TopProjectCell.swift
//  Mad
//
//  Created by MAC on 14/09/2021.
//



import UIKit

class TopProjectCell : UICollectionViewCell {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var shimmerView : ShimmerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showShimmer = false
    }
    
    
    
    func confic (name : String,date : String,title : String , projectUrl :String, profile :String){
        
        NameLbl.text = name
        NameLbl.numberOfLines = 2
        dateLbl.text = date
        titleLbl.text = title
        titleLbl.numberOfLines = 2
        if let projectUrl = URL(string: projectUrl){
        self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
    
        if let profileUrl = URL(string: profile){
        self.profileImage.kf.setImage(with: profileUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
        
    }
    
    
    
    var showShimmer: Bool = false {
        didSet {
        self.shimmerView.isShimmering = showShimmer
        }
    }
    
}
