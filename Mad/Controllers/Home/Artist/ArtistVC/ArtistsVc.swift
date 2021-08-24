//
//  ArtistsVc.swift
//  Mad
//
//  Created by MAC on 21/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import StagLayout

class ArtistsVc: UIViewController {
    
    @IBOutlet weak var  topActiveCollectionView: UICollectionView!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBOutlet weak var artistsView: UIView!
    @IBOutlet weak var suggestedView: UIView!

    @IBOutlet weak var suggestedTitle: UILabel!
    @IBOutlet weak var artistsTitle: UILabel!
    @IBOutlet weak var topActiveTitle: UILabel!

    
    var token = Helper.getAPIToken() ?? ""
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
    var page = 1
    var isFatching = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupeNib()
        getTopArtist(pageNum : page , catId : 31)
        getAllArtist(pageNum : page)
        if token != "" {
            self.suggestedView.isHidden = false
        }else{
            self.suggestedView.isHidden = true
        }
        getSuggested()
        
        suggestedTitle.text = "sugessted".localized
        artistsTitle.text = "artist".localized
        topActiveTitle.text = "topActive".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLayoutSubviews() {
        
        artistsView.addSubview(artistsCollectionView)
        artistsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistsCollectionView.leadingAnchor.constraint(equalTo: artistsView.leadingAnchor),
            artistsCollectionView.trailingAnchor.constraint(equalTo: artistsView.trailingAnchor),
            artistsCollectionView.topAnchor.constraint(equalTo: artistsView.topAnchor),
            artistsCollectionView.bottomAnchor.constraint(equalTo: artistsView.bottomAnchor)
        ])
    }
    
    
    func setupeNib() {
        topActiveCollectionView.delegate = self
        topActiveCollectionView.dataSource = self
        suggestedCollectionView.delegate = self
        suggestedCollectionView.dataSource = self
        artistsCollectionView.delegate = self
        artistsCollectionView.dataSource = self
        artistsCollectionView.prefetchDataSource = self
        artistsCollectionView.isPrefetchingEnabled = true
        
        self.topActiveCollectionView.register(UINib(nibName: cellIdentifier1, bundle: nil), forCellWithReuseIdentifier: cellIdentifier1)
        self.suggestedCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        self.artistsCollectionView.register(UINib(nibName: cellIdentifier3, bundle: nil), forCellWithReuseIdentifier: cellIdentifier3)
    }
    
    
    private let artistsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: StagLayout(widthHeightRatios: [(0.5, 0.5), (0.5, 1.5), (0.5, 1.0),(1.0, 1.0)], itemSpacing: 4)
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
}

extension ArtistsVc : UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDataSourcePrefetching{
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
                    if self.token != "" {
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
                    let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                    if let appDelegate = UIApplication.shared.delegate {
                        appDelegate.window??.rootViewController = sb
                    }
                    return
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
                if let bannerUrl = URL(string:   self.artists[indexPath.row].profilPicture ?? ""){
                cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
             }
             cell.showShimmer = showShimmer3
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showShimmer3 {return}

        if collectionView == artistsCollectionView {
        let vc = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProfileVc")  as! ArtistProfileVc
            vc.artistId = self.artists[indexPath.row].id ?? 0
            Helper.saveArtistId(id: self.artists[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == topActiveCollectionView{
            let vc = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProfileVc")  as! ArtistProfileVc
                vc.artistId = self.topActive[indexPath.row].id ?? 0
                Helper.saveArtistId(id: self.topActive[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProfileVc")  as! ArtistProfileVc
                vc.artistId = self.suggested[indexPath.row].id ?? 0
                Helper.saveArtistId(id: self.suggested[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= (artists.count) - 4  && isFatching{
                getAllArtist(pageNum: self.page)
                isFatching = false
                break
            }
        }
      }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= (artists.count) - 4  && isFatching{
            getAllArtist(pageNum: self.page)
            isFatching = false
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
            if self.suggested.count  > 0 {
                self.suggestedView.isHidden = false
            }else{
                self.suggestedView.isHidden = true
            }
             self.suggestedCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    func getAllArtist(pageNum : Int) {
        artistVM.getAllArtist(pageNum : pageNum).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer3 = false
            self.artists.append(contentsOf: dataModel.data?.data ?? [])
            self.artistsCollectionView.reloadData()
            if  self.page < dataModel.data?.countPages ?? 0 && !self.isFatching{
                self.isFatching = true
                self.page += 1
            }
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
