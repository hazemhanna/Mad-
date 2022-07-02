//
//  ArtistFeatureVideoVC.swift
//  Mad
//
//  Created by MAC on 26/02/2022.
//



import UIKit
import RxSwift
import RxCocoa
import AVKit
import AVFoundation


class ArtistVideoVC  : UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "ArtistVideosCell"
    var artistId = Helper.getArtistId() ?? 0    
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    
    var videos = [Videos](){
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        getArtistProfile(artistId : artistId)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension ArtistVideoVC : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! ArtistVideosCell
            cell.confic (title :videos[indexPath.row].title ?? "",
                         time :"1h 23mn" ,
                         like :videos[indexPath.row].favoriteCount ?? 0  ,
                         share : videos[indexPath.row].shareCount ?? 0,
                         imageUrl :videos[indexPath.row].imageURL ?? "",
                         isFavourite :videos[indexPath.row].isFavorite ?? false)
            cell.favourite = {
                if Helper.getAPIToken() ?? ""  == "" {
                    displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
                    let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                    if let appDelegate = UIApplication.shared.delegate {
                        appDelegate.window??.rootViewController = sb
                    }
                    return
                }
                
                self.artistVM.showIndicator()
                if  self.videos[indexPath.row].isFavorite ?? false {
                    self.editFavourite(videoId:  self.videos[indexPath.row].id ?? 0, Type: false)
                }else{
                  self.editFavourite(videoId:  self.videos[indexPath.row].id ?? 0, Type: true)
                }
            }
            
            cell.share = {
                if Helper.getAPIToken() ?? ""  == ""  {
                    displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
                    let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                    if let appDelegate = UIApplication.shared.delegate {
                        appDelegate.window??.rootViewController = sb
                    }
                return
                }
                self.shareVideo(videoId:  self.videos[indexPath.row].id ?? 0)
            }
            
            cell.openVideo = {
                if let url = self.videos[indexPath.row].videoURL{
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "VideoDetailsVc") as! VideoDetailsVc
        sb.videoId = self.videos[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
}

extension ArtistVideoVC{
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
               self.videos = dataModel.data?.videos ?? []
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    func editFavourite(videoId : Int,Type : Bool) {
        artistVM.addToFavourite(videoId: videoId, Type: Type).subscribe(onNext: { [self] (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }

    func shareVideo(videoId : Int) {
        artistVM.shareVideo(videoId: videoId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}
