//
//  ArtistVc.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class VideosVC: UIViewController {
   
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var  showsCollectionView: UICollectionView!
    @IBOutlet weak var interviewsCollectionView: UICollectionView!
    @IBOutlet weak var showCasesCollectionView: UICollectionView!
    @IBOutlet weak var afterMovieCollectionView: UICollectionView!
    
    var VideosVM = VideosViewModel()
    var parentVC : HomeVC?
    let cellIdentifier = "ProjectCell"
    let cellIdentifier2 = "ShowesCell"
    
    var showShimmer1: Bool = true
    var showShimmer2: Bool = true
   
    var categeory = [Category]()
    var shows = [Videos]()
    var interviews = [Videos]()
    var showsCases = [Videos]()
    var afterMoviews = [Videos]()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
    }
    
    func registerNib(){
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.showsCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        showsCollectionView.delegate = self
        showsCollectionView.dataSource = self
        self.interviewsCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        interviewsCollectionView.delegate = self
        interviewsCollectionView.dataSource = self
        self.showCasesCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        showCasesCollectionView.delegate = self
        showCasesCollectionView.dataSource = self
        self.afterMovieCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        afterMovieCollectionView.delegate = self
        afterMovieCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllVideos()
        getCategory()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

//MARK:- Data Binding
extension VideosVC: UICollectionViewDelegate , UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView {
            return  self.showShimmer1 ? 5 : categeory.count
            }else if collectionView == showsCollectionView{
                return  self.showShimmer2 ? 5 : self.shows.count
            }else if collectionView == interviewsCollectionView{
                return  self.showShimmer2 ? 5 : interviews.count
            }else if collectionView == showCasesCollectionView{
                return  self.showShimmer2 ? 5 : showsCases.count
            }else{
                return  self.showShimmer2 ? 5 : afterMoviews.count
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProjectCell
            if !self.showShimmer1 {
                    cell.catImage.isHidden = false
                    cell.addProjectBtn.isHidden = true
                    cell.projectNameLabel.textColor = UIColor.white
                    cell.projectNameLabel.text = self.categeory[indexPath.row].name ?? ""
                    if let url = URL(string:   self.categeory[indexPath.row].imageURL ?? ""){
                    cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Icon - Checkbox - Off"))
                    }
            }
            cell.showShimmer = showShimmer1
            return cell
        }else  if collectionView == showsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! ShowesCell
            if !self.showShimmer2 {
                cell.confic (title :shows[indexPath.row].title ?? "",
                             time :"1h 23mn" ,
                             like :shows[indexPath.row].favoriteCount ?? 0  ,
                             share : shows[indexPath.row].shareCount ?? 0,
                             imageUrl :shows[indexPath.row].imageURL ?? "",
                             isFavourite :shows[indexPath.row].isFavorite ?? false)

                
                cell.openDetails = {
                    let sb = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "VideoDetailsVc") as! VideoDetailsVc
                    sb.videoId = self.shows[indexPath.row].id ?? 0
                    self.navigationController?.pushViewController(sb, animated: true)
                }
            }
            cell.showShimmer = showShimmer2
            return cell
        }else  if collectionView == showCasesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! ShowesCell
            if !self.showShimmer2 {
                cell.confic (title :showsCases[indexPath.row].title ?? "",
                             time :"1h 23mn" ,
                             like :showsCases[indexPath.row].favoriteCount ?? 0  ,
                             share : showsCases[indexPath.row].shareCount ?? 0,
                             imageUrl :showsCases[indexPath.row].imageURL ?? "",
                             isFavourite :showsCases[indexPath.row].isFavorite ?? false)
                
                cell.openDetails = {
                    let sb = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "VideoDetailsVc") as! VideoDetailsVc
                    sb.videoId = self.showsCases[indexPath.row].id ?? 0

                    self.navigationController?.pushViewController(sb, animated: true)
                }
            }
            cell.showShimmer = showShimmer2
            return cell
        }else  if collectionView == interviewsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! ShowesCell
            if !self.showShimmer2 {
                cell.confic (title :interviews[indexPath.row].title ?? "",
                             time :"1h 23mn" ,
                             like :interviews[indexPath.row].favoriteCount ?? 0  ,
                             share : interviews[indexPath.row].shareCount ?? 0,
                             imageUrl :interviews[indexPath.row].imageURL ?? "",
                             isFavourite :interviews[indexPath.row].isFavorite ?? false)

                cell.openDetails = {
                    let sb = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "VideoDetailsVc") as! VideoDetailsVc
                    sb.videoId = self.interviews[indexPath.row].id ?? 0
                    self.navigationController?.pushViewController(sb, animated: true)
                }
            }
            cell.showShimmer = showShimmer2
            return cell
        }else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! ShowesCell
            if !self.showShimmer2 {
                cell.confic (title :afterMoviews[indexPath.row].title ?? "",
                             time :"1h 23mn" ,
                             like :afterMoviews[indexPath.row].favoriteCount ?? 0  ,
                             share : afterMoviews[indexPath.row].shareCount ?? 0,
                             imageUrl :afterMoviews[indexPath.row].imageURL ?? "",
                             isFavourite :afterMoviews[indexPath.row].isFavorite ?? false)

                cell.openDetails = {
                    let sb = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "VideoDetailsVc") as! VideoDetailsVc
                    sb.videoId = self.afterMoviews[indexPath.row].id ?? 0
                    self.navigationController?.pushViewController(sb, animated: true)
                }
            }
            cell.showShimmer = showShimmer2
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == afterMovieCollectionView{
           
        }
    }
    
}

extension VideosVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else  {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height)
        }
    }
}

extension VideosVC {
    
    func getCategory() {
        VideosVM.getCategories().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer1 = false
               self.categeory = dataModel.data ?? []
            self.productCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }

    
    func getAllVideos() {
        VideosVM.getAllVideos().subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
            self.showShimmer2 = false
            self.shows = dataModel.data?.Shows ?? []
            self.showsCases = dataModel.data?.Showcases ?? []
            self.afterMoviews = dataModel.data?.Aftermovies ?? []
            self.interviews = dataModel.data?.Interviews ?? []
                self.afterMovieCollectionView.reloadData()
                self.showCasesCollectionView.reloadData()
                self.showsCollectionView.reloadData()
                self.interviewsCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    func editFavourite(videoId : Int,Type : Bool) {
        VideosVM.addToFavourite(videoId: videoId, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.VideosVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.VideosVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    func shareProject(videoId : Int) {
        VideosVM.shareVideo(videoId: videoId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.VideosVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.VideosVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
}
