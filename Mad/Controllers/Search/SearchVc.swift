//
//  SearchVc.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit
import RxSwift
import RxCocoa



class SearchVc: UIViewController {

    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var searchTf : UITextField!

    var SearchVM = SearchViewModel()
    var disposeBag = DisposeBag()
    
    let cellIdentifier = "ArtistCell"
    var showShimmer : Bool = true
    var artists = [Artist]()
    var data : SearchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        self.popularCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPopularArtist()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func searchButton(sender: UIButton) {
        let main = SearchResultVc.instantiateFromNib()
        main!.data = self.data
        self.navigationController?.pushViewController(main!, animated: true)
        
    }
}

extension SearchVc : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 5 : artists.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ArtistCell
        if !self.showShimmer {
            if !self.showShimmer {
                cell.artistNameLabel.text = self.artists[indexPath.row].name ?? ""
                if let bannerUrl = URL(string:   self.artists[indexPath.row].profilPicture ?? ""){
                cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
                cell.mainStack.isHidden = true
             }
        }
        cell.showShimmer = showShimmer
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProfileVc")  as! ArtistProfileVc
            vc.artistId = self.artists[indexPath.row].id ?? 0
            Helper.saveArtistId(id: self.artists[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVc: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let  width : CGFloat = (collectionView.frame.size.width - space) / 3.5
            let height : CGFloat = 140
            return CGSize(width: width, height: height)
    }
}

extension SearchVc{
func getPopularArtist() {
    SearchVM.getPopular().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.showShimmer = false
        self.artists = dataModel.data?.popularArtists ?? []
        self.data = dataModel.data
        self.popularCollectionView.reloadData()
       }
   }, onError: { (error) in

   }).disposed(by: disposeBag)
}
}
