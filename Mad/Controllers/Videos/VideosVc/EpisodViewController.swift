//
//  EpisodViewController.swift
//  Mad
//
//  Created by MAC on 09/07/2022.
//


import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar
import AVKit
import AVFoundation

class EpisodViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var bannerImage : UIImageView!
    @IBOutlet weak var likeLbl : UILabel!
    @IBOutlet weak var shareLbl : UILabel!
    @IBOutlet weak var likeBtn : UIButton!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var pauseButton : UIButton!
   
    var token =  Helper.getAPIToken() ?? ""
    var videoId = Int()
    private let cellIdentifier = "EpisodTableViewCell"

    var videoVM = VideosViewModel()
    var disposeBag = DisposeBag()
    var isFavorite = false

    var videoUrl:String?

    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getVideoDetails(id : self.videoId)
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func favouriteBtn(sender: UIButton) {
 
        if self.token == "" {
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
            return
        }
        self.videoVM.showIndicator()
        if isFavorite{
            self.editFavourite(videoId:  videoId, Type: false)
            self.likeBtn.setImage(#imageLiteral(resourceName: "Path 326"), for: .normal)
        }else{
         self.editFavourite(videoId:  videoId, Type: true)
         self.likeBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
     }
    }
    
    @IBAction func shareBtn(sender: UIButton) {
        if self.token == "" {
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
            return
        }
        self.videoVM.showIndicator()
        self.shareVideo(videoId: self.videoId)
    }
    
    
    
     
    
    
    @IBAction func playvideoAction(_ sender: UIButton) {
            if let url = videoUrl {
            guard let videoURL = URL(string:  url) else { return }
            let video = AVPlayer(url: videoURL)
                let videoPlayer = AVPlayerViewController()
                videoPlayer.player = video
                videoPlayer.modalPresentationStyle = .overFullScreen
                videoPlayer.modalTransitionStyle = .crossDissolve
                self.present(videoPlayer, animated: true, completion: {
                    video.play()
                })
        }
    }
}

extension EpisodViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! EpisodTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "VideoDetailsVc") as! VideoDetailsVc
        sb.videoId = self.videoId
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
}

extension EpisodViewController {
    
    func getVideoDetails(id : Int) {
        videoVM.getVideoDetails(id: id).subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
            if let bannerUrl = URL(string: dataModel.data?.imageURL ?? "" ){
                   self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
                self.videoUrl = dataModel.data?.videoURL ?? ""
                self.likeLbl.text = "\(dataModel.data?.favoriteCount ?? 0)"
                self.shareLbl.text = "\(dataModel.data?.shareCount ?? 0)"
                self.titleLbl.text =  dataModel.data?.title ?? ""
                self.isFavorite = dataModel.data?.isFavorite ?? false
                if dataModel.data?.isFavorite ?? false {
                self.likeBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
                }else{
                self.likeBtn.setImage(#imageLiteral(resourceName: "Path 326"), for: .normal)
                }
            }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    func editFavourite(videoId : Int,Type : Bool) {
        videoVM.addToFavourite(videoId: videoId, Type: Type).subscribe(onNext: { [self] (dataModel) in
           if dataModel.success ?? false {
            self.videoVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
            self.getVideoDetails(id : self.videoId)
           }
       }, onError: { (error) in
        self.videoVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }

    func shareVideo(videoId : Int) {
        videoVM.shareVideo(videoId: videoId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.videoVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
            self.getVideoDetails(id : self.videoId)
               let text =  "https://mader.page.link/"
               let textToShare = [text] as [Any]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view
               activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
               self.present(activityViewController, animated: true, completion: nil)

           }
       }, onError: { (error) in
        self.videoVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}
