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


class ArtistFeatureVideoVC  : UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var availableLbl : UILabel!

    
    let cellIdentifier = "ArtistFeaturedVideosCell"
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artistId = Helper.getArtistId() ?? 0
    
    var videos = [Videos](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        getArtistProfile(artistId : artistId )

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension ArtistFeatureVideoVC : UITableViewDelegate,UITableViewDataSource{
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! ArtistFeaturedVideosCell
        
            cell.confic(title :videos[indexPath.row].title ?? "",
                         time :"1h 23mn" ,
                         imageUrl : videos[indexPath.row].imageURL ?? "")
        

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
        return 260
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "VideoDetailsVc") as! VideoDetailsVc
        sb.videoId = self.videos[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
}

extension ArtistFeatureVideoVC{
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
               self.videos = dataModel.data?.featured ?? []
               if dataModel.data?.featured?.count ?? 0  > 0 {
                   self.tableView.isHidden = false
                   self.availableLbl.isHidden = true

               }else{
                   self.tableView.isHidden = true
                   self.availableLbl.isHidden = false
               }
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
