//
//  EventChatCell.swift
//  EasyRemessa-iOS
//
//  Created by MAC on 10/03/2021.
//  Copyright © 2021 Yahya Tabba. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var MessageContentView: CustomView!
    @IBOutlet weak var MessageContentTV: CustomTextView!
    @IBOutlet weak var UserContentView: UIStackView!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var MessageContent: CustomView!
    @IBOutlet weak var dateContentView: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var productContentView: UIStackView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MessageContentTV.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        MessageContentTV.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(Message: String, ReceiverFlag: Bool,name:String,image : String) {
        if ReceiverFlag {
            self.MessageContentView.semanticContentAttribute = .forceLeftToRight
            self.UserContentView.alignment = .leading
            MessageContentTV.textAlignment = .left
            MessageContentTV.textColor = #colorLiteral(red: 0.153167218, green: 0.2862507105, blue: 0.4761998057, alpha: 1)
            MessageContent.layer.masksToBounds = true
        } else {
            self.MessageContentView.semanticContentAttribute = .forceRightToLeft
            self.UserContentView.alignment = .trailing
            MessageContentTV.textAlignment = .right
            MessageContentTV.textColor = #colorLiteral(red: 0.153167218, green: 0.2862507105, blue: 0.4761998057, alpha: 1)
            MessageContent.layer.masksToBounds = true
        }
        self.MessageContentTV.text = Message
        self.nameLbl.text = name
        if let profileImageUrl = URL(string: image){
        self.profileImage.kf.setImage(with: profileImageUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
        
        self.MessageContentTV.sizeToFit()
        self.MessageContentTV.layoutIfNeeded()
    }
}

