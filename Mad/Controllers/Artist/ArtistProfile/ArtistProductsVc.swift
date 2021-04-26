//
//  ArtistProductsVc.swift
//  Mad
//
//  Created by MAC on 23/04/2021.
//

import UIKit

class ArtistProductsVc: UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!

    let cellIdentifier = "LiveCellCVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

  
}
extension ArtistProductsVc :  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LiveCellCVC
        cell.editBtn.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
}
extension ArtistProductsVc : UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    
        let size:CGFloat = (collectionView.frame.size.width - space) - 32
            return CGSize(width: size, height: 140)
        }
    
}
