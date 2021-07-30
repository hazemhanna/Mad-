//
//  ProfileVc.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MyProfileVc: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var favouriteCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var  upgradeView : UIView!
    
    var active = Helper.getIsActive() ?? false
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if active{
            upgradeView.isHidden = true
        }else{
            upgradeView.isHidden = false

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func menuButton(sender: UIButton) {
        let main = MenuVC.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func upgradeButton(sender: UIButton) {


    }
    
    
}

extension MyProfileVc  {
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.artistName.text = dataModel.data?.name ??  ""
            self.artistName.text = dataModel.data?.name ??  ""
            self.artistName.text = dataModel.data?.name ??  ""
            self.favouriteCount.text = "\(dataModel.data?.allFollowers ?? 0)"
            self.followersCount.text = "\(dataModel.data?.allFollowing ?? 0)"
            if let profile = URL(string:   dataModel.data?.profilPicture ??  "" ){
            self.ProfileImage.kf.setImage(with: profile, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
            if let bannerUrl = URL(string:   dataModel.data?.bannerImg ??  "" ){
            self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
