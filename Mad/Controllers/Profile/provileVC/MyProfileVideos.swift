//
//  MyProfileVideos.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//



import UIKit
import RxSwift
import RxCocoa
import AVKit
import AVFoundation


class MyProfileVideos : UIViewController{
    
    @IBOutlet weak var uploadBtn : UIButton!
    @IBOutlet weak var videoCollectionView : UICollectionView!
    @IBOutlet weak var nameTf : UITextField!
    @IBOutlet weak var uploadStack : UIStackView!
    @IBOutlet weak var videoView : UIView!

    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    
    let cellIdentifier2 = "ShowesCell"
    var showShimmer: Bool = true
    var videos = [Videos]()    
    var videoUrl :Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfile()
        videoView.isHidden = false
        uploadStack.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func upload(sender: UIButton) {
        self.showImageActionSheet()
     }
    
    @IBAction func submit(sender: UIButton) {
        if nameTf.text == "" {
            displayMessage(title: "", message:  "Enter Video Name" , status: .error, forController: self)

        }else{
        if let url = self.videoUrl {
          artistVM.showIndicator()
          uploadVideo(name: nameTf.text ?? "",agree: true, videoUrl: url )
        }else{
            displayMessage(title: "", message:  "Upload Your Video " , status: .error, forController: self)
        }
      }
    }
    
    
    
    @IBAction func uploadVideo(sender: UIButton) {
        videoView.isHidden = true
        uploadStack.isHidden = false
    }
 
    @IBAction func cancel(sender: UIButton) {
        videoView.isHidden = false
        uploadStack.isHidden = true
    }
    
}

//MARK:- Data Binding
extension MyProfileVideos: UICollectionViewDelegate , UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
        return  self.showShimmer ? 5 : videos.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! ShowesCell
            if !self.showShimmer {
                cell.confic (title :videos[indexPath.row].title ?? "",
                             time :"1h 23mn" ,
                             like :videos[indexPath.row].favoriteCount ?? 0  ,
                             share : videos[indexPath.row].shareCount ?? 0,
                             imageUrl :videos[indexPath.row].imageURL ?? "",
                             isFavourite :videos[indexPath.row].isFavorite ?? false)
                
                
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
            }
        
            cell.showShimmer = showShimmer
            return cell
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.showShimmer {return}
        
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
}
    
extension MyProfileVideos: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size:CGFloat = (collectionView.frame.size.width)
            return CGSize(width: size, height: 150)
    }
}


extension MyProfileVideos: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func showImageActionSheet() {
        self.showImagePicker(sourceType: .photoLibrary)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let videoUrl = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as? URL else {return}

             self.uploadBtn.setTitle(videoUrl.lastPathComponent, for: .normal)
              do {
                self.uploadBtn.setImage(nil, for: .normal)
                let data = try Data(contentsOf: videoUrl, options: .mappedIfSafe)
                self.videoUrl =  data
                print(data)
                } catch  {
                    
                }
             dismiss(animated: true, completion: nil)
    }
}


extension MyProfileVideos{
    func uploadVideo(name : String,agree : Bool,videoUrl: Data) {
        artistVM.uploadVideo(name: name, agree: agree, videoUrl: videoUrl).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.uploadBtn.setTitle("", for: .normal)
            self.uploadBtn.setImage(#imageLiteral(resourceName: "Path 412"), for: .normal)
            self.nameTf.text = ""
            self.videoView.isHidden = false
            self.uploadStack.isHidden = true
            displayMessage(title: "", message: dataModel.message  ?? "" , status: .success, forController: self)
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    func getProfile() {
        artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.videos = dataModel.data?.videos?.reversed() ?? []
            self.videoCollectionView.reloadData()
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
