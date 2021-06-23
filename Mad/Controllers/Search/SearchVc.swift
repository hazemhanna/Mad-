//
//  SearchVc.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit

class SearchVc: UIViewController {

    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var searchTf : UITextField!

    let cellIdentifier = "ArtistCell"
    var showShimmer : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        self.popularCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func searchButton(sender: UIButton) {
        let main = SearchResultVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
        
    }
}

extension SearchVc : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 5 : 7
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ArtistCell
        if !self.showShimmer {
            if !self.showShimmer {
//                cell.artistNameLabel.text = self.artists[indexPath.row].name ?? ""
//                cell.favouriteCount.text = "\(self.artists[indexPath.row].allFollowers ?? 0)"
//                cell.followerCount.text = "\(self.artists[indexPath.row].allFollowing ?? 0)"
//                if let bannerUrl = URL(string:   self.artists[indexPath.row].bannerImg ?? ""){
//                cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
//               }
                cell.mainStack.isHidden = true
             }
        }
        cell.showShimmer = showShimmer
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
}

extension SearchVc: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let  width : CGFloat = (collectionView.frame.size.width - space) / 2
            let height : CGFloat = 140
            return CGSize(width: width, height: height)
    }
}
