//
//  VideoPartners.swift
//  Mad
//
//  Created by MAC on 19/05/2021.
//


import UIKit

class VideoPartners : UIViewController {

    @IBOutlet weak var PartenerCollectionView: UICollectionView!

    let cellIdentifier = "VideoPartenerCell"
    var showShimmer: Bool = true
    var parentVC : VideoDetailsVc?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.PartenerCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

        PartenerCollectionView.delegate = self
        PartenerCollectionView.dataSource = self
        
    }


}

extension VideoPartners: UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 2 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! VideoPartenerCell
         if !self.showShimmer {
        
        }
        cell.showShimmer = showShimmer
        return cell
      }

    }

extension VideoPartners : UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2
        return CGSize(width: size, height: 150)
        }
}
