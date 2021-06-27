//
//  ArtistProfileVc.swift
//  Mad
//
//  Created by MAC on 20/04/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ArtistProfileVc: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var favouriteCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var followBtn: UIButton!


    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artistId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        artistVM.showIndicator()
         getArtistProfile(artistId : artistId)

    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension ArtistProfileVc  {
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.artistName.text = dataModel.data?.name ??  ""
            self.artistName.text = dataModel.data?.name ??  ""
            self.artistName.text = dataModel.data?.name ??  ""
            self.favouriteCount.text = "\(dataModel.data?.allFollowers ?? 0)"
            self.followersCount.text = "\(dataModel.data?.allFollowing ?? 0)"
            self.followingCount.text = "\(dataModel.data?.allFollowing ?? 0)"
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
