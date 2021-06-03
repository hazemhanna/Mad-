
//  ProjectPhotosVC.swift
//  Mad
//
//  Created by MAC on 01/06/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar
import Photos


class AddProjectPhotosVC : UIViewController ,UINavigationControllerDelegate{
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!

    var imageArray=[UIImage]()
    let cellIdentifier = "AddProductPhotoCell"

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
        grabPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }

    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton(sender: UIButton) {
        let vc = ListingDetailsVC.instantiateFromNib()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: grab photos
    func grabPhotos(){
        imageArray = []
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            let imgManager=PHImageManager.default()
            
            let requestOptions=PHImageRequestOptions()
            requestOptions.isSynchronous=true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions=PHFetchOptions()
            fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult)
            print(fetchResult.count)
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("You got no photos.")
            }
            print("imageArray count: \(self.imageArray.count)")
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                self.photoCollectionView.reloadData()
            }
        }
    }

}

extension AddProjectPhotosVC : UICollectionViewDelegate ,UICollectionViewDataSource{


    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AddProductPhotoCell
        cell.productImage.isHidden = false
        cell.productImage.image = imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
            return CGSize(width: width/3 - 1, height: width/3 - 1)
    }
    
    
    
}
