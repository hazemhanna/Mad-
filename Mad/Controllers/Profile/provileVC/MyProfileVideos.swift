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
import WSTagsField


class MyProfileVideos : UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var uploadBtn : UIButton!
    @IBOutlet weak var videoCollectionView : UICollectionView!
    @IBOutlet weak var nameTf : UITextField!
    @IBOutlet weak var uploadStack : UIStackView!
    @IBOutlet weak var videoView : UIView!
    @IBOutlet weak var uploadedImage : UIImageView!

    
    @IBOutlet weak var descTF: CustomTextField!
    @IBOutlet fileprivate weak var artistView: UIView!
    @IBOutlet fileprivate weak var productView: UIView!
    @IBOutlet fileprivate weak var projectView: UIView!

    
    fileprivate let artistField = WSTagsField()
    fileprivate let productField = WSTagsField()
    fileprivate let projectField = WSTagsField()

    
    
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    
    let cellIdentifier2 = "ShowesCell"
    var showShimmer: Bool = true
    var videos = [Videos]()    
    var videoUrl :Data?
    var image :UIImage?

    var selectedArtist = [String]()
    var selectedProducts = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        
        artistField.frame = artistView.bounds
        artistView.addSubview(artistField)
        artistField.cornerRadius = 3.0
        artistField.spaceBetweenLines = 10
        artistField.spaceBetweenTags = 10
        artistField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        artistField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding
        artistField.placeholder = ""
        artistField.placeholderColor = .red
        artistField.placeholderAlwaysVisible = true
        artistField.backgroundColor = .clear
        artistField.textField.returnKeyType = .continue
        artistField.delimiter = ""
        artistField.tintColor = #colorLiteral(red: 0.9058823529, green: 0.9176470588, blue: 0.937254902, alpha: 1)
        artistField.textColor = #colorLiteral(red: 0.1749513745, green: 0.2857730389, blue: 0.4644193649, alpha: 1)
        artistField.textDelegate = self
        artistTextFieldEvents()
        
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
    
    
    @IBAction func uploadImage(sender: UIButton) {
        self.showImageActionSheet2()
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
    
    fileprivate func artistTextFieldEvents() {
        
        artistField.onDidChangeText = { _, text in
            print("onDidChangeText")
            let vc = ArtistNameVC.instantiateFromNib()
            vc?.showArtist = true
            vc!.onClickClose = { artist in
            self.selectedArtist.append(String(artist.id ?? 0))
            self.artistField.addTag(artist.name ?? "")
             self.presentingViewController?.dismiss(animated: true)
           }
            self.present(vc!, animated: true, completion: nil)
        }

        artistField.onDidAddTag = { field, tag in
            print("onDidAddTag", tag.text)
         
        }
        
        artistField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
        }

        
        artistField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")

        }

        artistField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }
        artistField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
        artistField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
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

        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.image = editedImage
            self.uploadedImage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = originalImage
            self.uploadedImage.image = originalImage


        }else if let videoUrl = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as? URL  {
            self.uploadBtn.setTitle(videoUrl.lastPathComponent, for: .normal)
                 
            do {
                    self.uploadBtn.setImage(nil, for: .normal)
                    let data = try Data(contentsOf: videoUrl, options: .mappedIfSafe)
                    self.videoUrl =  data
                    print(data)
                    } catch  {
                        
             }
        }
      dismiss(animated: true, completion: nil)
    }
}

extension MyProfileVideos{
    
    func showImageActionSheet2() {
        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
                self.showImagePicker2(sourceType: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "Take a Picture from Camera", style: .default) { (action) in
                self.showImagePicker2(sourceType: .camera)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            AlertService.showAlert(style: .actionSheet, title: "Pick Your Picture", message: nil, actions: [chooseFromLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePicker2(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.present(imagePickerController, animated: true, completion: nil)
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
