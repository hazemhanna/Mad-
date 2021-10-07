//
//  MyProfileVideos.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//



import UIKit
import RxSwift
import RxCocoa

class MyProfileVideos : UIViewController{
    
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var uploadBtn : UIButton!
    @IBOutlet weak var nameTf : UITextField!
    var videoUrl :URL?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
  

    
    @IBAction func upload(sender: UIButton) {
        self.showImageActionSheet()
    }
    
   
    @IBAction func submit(sender: UIButton) {
        if let url = self.videoUrl {
          artistVM.showIndicator()
          uploadVideo(name: nameTf.text ?? "",agree: true, videoUrl: url )
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

        guard let videoUrl = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as? URL else {return}
        
             self.videoUrl = videoUrl
              print(videoUrl)
              do {
                  // self.uploadBtn.setTitle(try String(contentsOf: videoUrl), for: .normal)
                    let data = try Data(contentsOf: videoUrl, options: .mappedIfSafe)
                    print(data)
                } catch  {
                    
                }
             dismiss(animated: true, completion: nil)
    }
}


extension MyProfileVideos{
    func uploadVideo(name : String,agree : Bool,videoUrl: URL) {
        artistVM.uploadVideo(name: name, agree: agree, videoUrl: videoUrl).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
