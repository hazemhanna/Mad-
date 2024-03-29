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
import PTCardTabBar
import FirebaseDynamicLinks

class ArtistProfileVc: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var favouriteCount: UILabel!
    @IBOutlet weak var artistName: UILabel!
    var token = Helper.getAPIToken() ?? ""
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artistId = Int()
    var isFavorite = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        artistVM.showIndicator()
         getArtistProfile(artistId : artistId)
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtn(sender: UIButton) {
         if self.token == "" {
            displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {appDelegate.window??.rootViewController = sb}
            return
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/artist"
        let artistItem = URLQueryItem(name: "artistId", value: "\(self.artistId)")
        components.queryItems = [artistItem]
         guard  let linkParameter = components.url else {return}
         guard let sharing = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://mader.page.link")else {return}
        if let bundleID = Bundle.main.bundleIdentifier {sharing.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)}
        sharing.iOSParameters?.appStoreID = ""
        sharing.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharing.socialMetaTagParameters?.title = artistName.text
        sharing.shorten{ (url , warnning , error) in
            guard let url  = url else {return}
            self.share(url: url)
        }
    }
    
     func share(url: URL)  {
        let textToShare = [url] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
       activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
      self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func messageButton(sender: UIButton) {
        if Helper.getAPIToken() != nil {
            flloweArtist(artistId: artistId, Type: true)
        }else {
         displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
         let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
         if let appDelegate = UIApplication.shared.delegate {
             appDelegate.window??.rootViewController = sb
             
        }
     }
   }
    
}

extension ArtistProfileVc  {
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.artistName.text = dataModel.data?.name ??  ""
            self.favouriteCount.text = "\(dataModel.data?.allFollowers ?? 0)"
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
    
    func flloweArtist(artistId : Int,Type : Bool) {
        artistVM.addToFavourite(artistId: artistId, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
              self.artistVM.dismissIndicator()
               let vc = SendMessageVc.instantiateFromNib()
               vc?.artistId = self.artistId
               vc?.fromArtistPage = true
               vc?.tagsField.addTag(self.artistName.text ?? "")
               self.navigationController?.pushViewController(vc!, animated: true)
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
