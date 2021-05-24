//
//  ArtistsVc.swift
//  Mad
//
//  Created by MAC on 21/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ArtistsVc: UIViewController {
    
    @IBOutlet weak var  topActiveCollectionView: UICollectionView!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBOutlet weak var artistsCollectionView: UICollectionView!
    let cellIdentifier1 = "ProjectCell"
    let cellIdentifier2 = "SuggestedCell"
    let cellIdentifier3 = "ArtistCell"
    var parentVC : HomeVC?
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artists = [Artist]()
    var suggested = [Artist]()
    var topActive = [Artist]()
    var showShimmer1: Bool = true
    var showShimmer2: Bool = true
    var showShimmer3: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupeNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTopArtist(pageNum : 1 , catId : 31)
        getAllArtist(pageNum : 1)
        getSuggested()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupeNib() {
        topActiveCollectionView.delegate = self
        topActiveCollectionView.dataSource = self
        suggestedCollectionView.delegate = self
        suggestedCollectionView.dataSource = self
        artistsCollectionView.delegate = self
        artistsCollectionView.dataSource = self
        self.topActiveCollectionView.register(UINib(nibName: cellIdentifier1, bundle: nil), forCellWithReuseIdentifier: cellIdentifier1)
        self.suggestedCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        self.artistsCollectionView.register(UINib(nibName: cellIdentifier3, bundle: nil), forCellWithReuseIdentifier: cellIdentifier3)
    }
    
}

extension ArtistsVc : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topActiveCollectionView {
        return  self.showShimmer1 ? 5 : topActive.count
        }else if collectionView == suggestedCollectionView{
            return  self.showShimmer2 ? 2 : suggested.count
        }else{
            return  self.showShimmer3 ? 5 : artists.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topActiveCollectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier1, for: indexPath) as! ProjectCell
        if !self.showShimmer1 {
                cell.catImage.isHidden = false
                cell.addProjectBtn.isHidden = true
                cell.projectNameLabel.text = self.topActive[indexPath.row].headline ?? ""
                cell.ProjectView.layer.cornerRadius = 14
                if let url = URL(string:   self.topActive[indexPath.row].profilPicture ?? ""){
                cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
            }
         }
         cell.showShimmer = showShimmer1
        return cell
        }else if collectionView == suggestedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! SuggestedCell
            if !self.showShimmer2 {
                cell.confic(name : self.suggested[indexPath.row].name ?? "" , bannerImg : self.suggested[indexPath.row].bannerImg ?? "",profilPicture: self.suggested[indexPath.row].profilPicture ?? "",isFavourite: self.suggested[indexPath.row].isFavorite ?? false,art: self.suggested[indexPath.row].art ?? false,music: self.suggested[indexPath.row].music ?? false ,design: self.suggested[indexPath.row].design ?? false)
                
                cell.editFavourite = {
                    if Helper.getAPIToken() != nil {
                    self.artistVM.showIndicator()
                 if self.suggested[indexPath.row].isFavorite ?? false{
                    self.editFavourite(artistId:  self.suggested[indexPath.row].id ?? 0, Type: false)
                    cell.favouriteBtn.backgroundColor = #colorLiteral(red: 0.9282042384, green: 0.2310142517, blue: 0.4267850518, alpha: 1)
                    self.suggestedCollectionView.reloadData()
                    }else{
                        self.editFavourite(artistId:  self.suggested[indexPath.row].id ?? 0, Type: true)
                        cell.favouriteBtn.backgroundColor = #colorLiteral(red: 0.5764705882, green: 0.6235294118, blue: 0.7137254902, alpha: 1)
                        self.suggestedCollectionView.reloadData()
                   }
                   }else {
                    self.showMessage(text: "please login first")
                 }
                }
            }
             cell.showShimmer = showShimmer2
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier3, for: indexPath) as! ArtistCell
            if !self.showShimmer3 {
                cell.artistNameLabel.text = self.artists[indexPath.row].name ?? ""
                cell.favouriteCount.text = "\(self.artists[indexPath.row].allFollowers ?? 0)"
                cell.followerCount.text = "\(self.artists[indexPath.row].allFollowing ?? 0)"
                if let bannerUrl = URL(string:   self.artists[indexPath.row].bannerImg ?? ""){
                cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
             }
             cell.showShimmer = showShimmer3
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == artistsCollectionView {
        if showShimmer3 {return}
        let vc = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProfileVc")  as! ArtistProfileVc
            vc.artistId = self.artists[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension ArtistsVc: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topActiveCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else if collectionView == suggestedCollectionView {

            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.5
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else{
            
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)

            let  width : CGFloat = (collectionView.frame.size.width - space) / 3.5
            let height : CGFloat = 140
            return CGSize(width: width, height: height)
        
        }
    }
}


extension ArtistsVc {
    func getSuggested() {
        artistVM.getSuggested().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer2 = false
            self.suggested = dataModel.data ?? []
             self.suggestedCollectionView.reloadData()

           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
   
    func getAllArtist(pageNum : Int) {
        artistVM.getAllArtist(pageNum : pageNum).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer3 = false
            self.artists = dataModel.data?.data ?? []
            self.artistsCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    
    func getTopArtist(pageNum : Int , catId : Int) {
        artistVM.getTopArtist(pageNum : pageNum , catId : catId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer1 = false
            self.topActive = dataModel.data?.data ?? []
            self.topActiveCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    
    func editFavourite(artistId : Int,Type : Bool) {
        artistVM.addToFavourite(artistId: artistId, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
            self.getSuggested()
            self.suggestedCollectionView.reloadData()
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }

    
}
