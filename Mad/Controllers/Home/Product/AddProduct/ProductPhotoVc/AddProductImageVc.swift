//
//  AddProductImageVc.swift
//  Mad
//
//  Created by MAC on 27/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar


class AddProductImageVc: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!

    var disposeBag = DisposeBag()
    var productVM = ProductViewModel()
    var uploadedPhoto = [UIImage]()
    var productPhoto = [AddPhotoModel]()
    let cellIdentifier = "AddProductPhotoCell"

    var isFromEdit = false
    var product : ProductDetailsModel?
    
    var images = [UIImage](){
        didSet{
            photoCollectionView.reloadData()
        }
    }

    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.5764705882, blue: 0.6745098039, alpha: 1)
        self.nextBtn.isEnabled = false
        self.photoCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.isScrollEnabled = false
        
        if !isFromEdit {
        self.productPhoto.append(AddPhotoModel(staticPhoto: #imageLiteral(resourceName: "Mask Group 89"), uploadedPhoto: nil, uploaded: false))
        self.productPhoto.append(AddPhotoModel(staticPhoto: #imageLiteral(resourceName: "Mask Group 90"), uploadedPhoto: nil, uploaded: false))
        self.productPhoto.append(AddPhotoModel(staticPhoto: #imageLiteral(resourceName: "Mask Group 91"), uploadedPhoto: nil, uploaded: false))
        self.productPhoto.append(AddPhotoModel(staticPhoto: #imageLiteral(resourceName: "Mask Group 94"), uploadedPhoto: nil, uploaded: false))
        self.productPhoto.append(AddPhotoModel(staticPhoto: #imageLiteral(resourceName: "Mask Group 93"), uploadedPhoto: nil, uploaded: false))
        self.productPhoto.append(AddPhotoModel(staticPhoto: #imageLiteral(resourceName: "Mask Group 92"), uploadedPhoto: nil, uploaded: false))
        self.productPhoto.append(AddPhotoModel(staticPhoto: #imageLiteral(resourceName: "Mask Group 97"), uploadedPhoto: nil, uploaded: false))
        self.productPhoto.append(AddPhotoModel(staticPhoto: #imageLiteral(resourceName: "Mask Group 95"), uploadedPhoto: nil, uploaded: false))
        }
        
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
        if isFromEdit {
            self.images.removeAll()
            self.nextBtn.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            self.nextBtn.isEnabled = true
            if product?.photos?.count  ?? 0 > 0 {
                for image in product?.photos ?? []{
                do{
                   let data = try Data.init(contentsOf: URL.init(string: image)!)
                   if let image: UIImage = UIImage(data: data) {
                    self.images.append(image)}}catch {}}
            }
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton(sender: UIButton) {
        if isFromEdit{
        let vc = ListingDetailsVC.instantiateFromNib()
            vc!.images = images
            vc?.isFromEdit = true
            vc?.product = product
           self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = ListingDetailsVC.instantiateFromNib()
            vc!.uploadedPhoto = uploadedPhoto
            self.navigationController?.pushViewController(vc!, animated: true)
    
        }
    }
}

extension AddProductImageVc: UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFromEdit {
            return images.count + 1
        }else{
           return productPhoto.count + 1
        }
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AddProductPhotoCell
    if indexPath.row == 0 {
        cell.productImage.isHidden = true
        cell.ProducttView.backgroundColor = UIColor(red: 209/255, green: 226/255, blue: 247/255, alpha: 1)
        cell.deleteBtn.isHidden = true

     }else{
        if isFromEdit {
            cell.productImage.isHidden = false
            cell.ProducttView.backgroundColor = UIColor.clear
            cell.productImage.image = images[indexPath.row - 1]
            cell.deleteBtn.isHidden = false
        }else{
         cell.productImage.isHidden = false
         cell.ProducttView.backgroundColor = UIColor.clear
         if productPhoto[indexPath.row - 1].uploaded {
           cell.productImage.image = productPhoto[indexPath.row - 1].uploadedPhoto
          }else{
             cell.productImage.image = productPhoto[indexPath.row - 1].staticPhoto
            }
        }
    }
    
       cell.deletePhoto = {
          if self.images.count > 1 {
              self.images.remove(at: indexPath.row - 1)
              self.photoCollectionView.reloadData()
          }
       }

       cell.addPhoto = {
          if self.uploadedPhoto.count < 8 {
          self.showImageActionSheet()
         }
       }
       
       if self.uploadedPhoto.count > 0  {
            self.nextBtn.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            self.nextBtn.isEnabled = true
        }
        return cell
   }
}

extension AddProductImageVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.1
        let height :CGFloat = (collectionView.frame.size.height - space) / 3.1
        return CGSize(width: size, height: height)
        
    }
}


extension AddProductImageVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImageActionSheet() {
        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
                self.showImagePicker(sourceType: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "Take a Picture from Camera", style: .default) { (action) in
                self.showImagePicker(sourceType: .camera)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            AlertService.showAlert(style: .actionSheet, title: "Pick Your Picture", message: nil, actions: [chooseFromLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
         if isFromEdit {
            self.images.append(editedImage)
            self.photoCollectionView.reloadData()
          }else{
             self.productPhoto.removeFirst()
             self.uploadedPhoto.append(editedImage)
             self.productPhoto.append(AddPhotoModel(staticPhoto: nil, uploadedPhoto: editedImage, uploaded: true))
             self.photoCollectionView.reloadData()
            }
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if isFromEdit {
            self.images.append(originalImage)
            self.photoCollectionView.reloadData()
            }else{
            self.productPhoto.removeFirst()
            self.uploadedPhoto.append(originalImage)
            self.productPhoto.append(AddPhotoModel(staticPhoto: nil, uploadedPhoto: originalImage, uploaded: true))
            self.photoCollectionView.reloadData()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        self.init(data: imageData)
    }
}
