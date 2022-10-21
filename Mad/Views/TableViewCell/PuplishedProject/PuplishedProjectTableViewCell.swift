//
//  PuplishedProjectTableViewCell.swift
//  Mad
//
//  Created by MAC on 08/10/2022.
//

import UIKit

class PuplishedProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ordersLbl: UILabel!
    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var hideSwitch: UISwitch!
    @IBOutlet weak var projectImage: UIImageView!
    
    var hideProject: (() -> Void)? = nil
    var showProject: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()        
        hideSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
    }

    func confic (projectUrl :String,name : String,price : String , view : String,orders : String ){
        NameLbl.text = name
        NameLbl.numberOfLines = 2
        priceLbl.text = price
        viewLbl.text = view
        ordersLbl.text = orders
        
        if let projectUrl = URL(string: projectUrl){
        self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
    }
    
    @objc func switchValueDidChange() {
        if(hideSwitch.isOn) {
            hideProject?()
        }else {
            showProject?()
        }
    }
    
}
