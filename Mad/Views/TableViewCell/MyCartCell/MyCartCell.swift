//
//  MyCartCell.swift
//  Mad
//
//  Created by MAC on 04/07/2021.
//

import UIKit

class MyCartCell: UITableViewCell {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productmage: UIImageView!
    @IBOutlet weak var shimmerView : ShimmerView!

    var plus : (() -> Void)? = nil
    var minus : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()

        showShimmer = false
    }

    var showShimmer: Bool = false {
        didSet {
            self.shimmerView.isShimmering = showShimmer
        }
    }

    
    func confic(name : String , productUrl : String , price : String , count : String){
        NameLbl.text = name
        countLbl.text = name
        priceLbl.text = name
        
        if  let productUrl = URL(string: productUrl){
            self.productmage.kf.setImage(with: productUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func plusAction(_ sender: UIButton) {
        self.plus?()
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        self.minus?()
    }
    
}
