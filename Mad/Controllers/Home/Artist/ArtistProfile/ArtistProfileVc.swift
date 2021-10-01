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
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artistId = Int()
    var isFavorite = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followBtn.setTitle("follow".localized, for: .normal)
        messageBtn.setTitle("message".localized, for: .normal)
        
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
    
    @IBAction func followButton(sender: UIButton) {
        if Helper.getAPIToken() != nil {
        self.artistVM.showIndicator()
     if isFavorite{
        self.flloweArtist(artistId:  self.artistId, Type: false)
        followBtn.backgroundColor = #colorLiteral(red: 0.9282042384, green: 0.2310142517, blue: 0.4267850518, alpha: 1)
        }else{
            self.flloweArtist(artistId:  self.artistId, Type: true)
            followBtn.backgroundColor = #colorLiteral(red: 0.5764705882, green: 0.6235294118, blue: 0.7137254902, alpha: 1)
       }
       }else {
        
        displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)

        let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = sb
        }
        return
      }
    }
    
    @IBAction func messageButton(sender: UIButton) {
        let vc = SendMessageVc.instantiateFromNib()
        vc?.artistId = self.artistId
        vc?.fromArtistPage = true
        vc?.tagsField.addTag(self.artistName.text ?? "")
        self.navigationController?.pushViewController(vc!, animated: true)
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
            self.isFavorite = dataModel.data?.isFavorite ?? false
            self.favouriteCount.text = "\(dataModel.data?.allFollowers ?? 0)"
            self.followersCount.text = "\(dataModel.data?.allFollowing ?? 0)"
            if let profile = URL(string:   dataModel.data?.profilPicture ??  "" ){
            self.ProfileImage.kf.setImage(with: profile, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
            self.isFavorite = dataModel.data?.isFavorite ??  false
            if dataModel.data?.isFavorite ??  false{
                self.followBtn.backgroundColor = #colorLiteral(red: 0.5764705882, green: 0.6235294118, blue: 0.7137254902, alpha: 1)
               }else{
                self.followBtn.backgroundColor = #colorLiteral(red: 0.9282042384, green: 0.2310142517, blue: 0.4267850518, alpha: 1)
              }
            
            if let bannerUrl = URL(string:   dataModel.data?.bannerImg ??  "" ){
            self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    func flloweArtist(artistId : Int,Type : Bool) {
        artistVM.addToFavourite(artistId: artistId, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.getArtistProfile(artistId : artistId)
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
