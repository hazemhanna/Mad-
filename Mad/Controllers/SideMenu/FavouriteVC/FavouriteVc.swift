//
//  FavouriteVc.swift
//  Mad
//
//  Created by MAC on 09/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class FavouriteVc: UIViewController {
    
    @IBOutlet weak var projectTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var artistTableView: UITableView!
    @IBOutlet weak var videoTableView: UITableView!
    
    @IBOutlet weak var projectView: UIView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var artistView: UIView!
    @IBOutlet weak var videoView: UIView!

    let cellIdentifier = "FavouritProjectCell"
    let cellIdentifier2 = "FavouritProjectCell"
    let cellIdentifier3 = "FavouriteArtistCell"
    let cellIdentifier4 = "FavouritVideoCell"
    
    var disposeBag = DisposeBag()
    var favouriteVM = FavouriteViewModel()

    var artists = [Artist]()
    var products = [Product]()
    var projects = [Project]()
    var video = [Videos]()

    var showShimmer: Bool = true
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavourite()
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension FavouriteVc: UITableViewDelegate,UITableViewDataSource{
    func setupContentTableView() {
        self.artistTableView.register(UINib(nibName: self.cellIdentifier3, bundle: nil), forCellReuseIdentifier: self.cellIdentifier3)
        artistTableView.delegate = self
        artistTableView.dataSource = self

        self.productTableView.register(UINib(nibName: self.cellIdentifier2, bundle: nil), forCellReuseIdentifier: self.cellIdentifier2)
        productTableView.delegate = self
        productTableView.dataSource = self
        
        self.projectTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        projectTableView.delegate = self
        projectTableView.dataSource = self
        
        self.videoTableView.register(UINib(nibName: self.cellIdentifier4, bundle: nil), forCellReuseIdentifier: self.cellIdentifier4)
        videoTableView.delegate = self
        videoTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     if tableView == projectTableView {
        return  self.showShimmer ? 2 : projects.count
     }else if tableView == productTableView {
        return self.showShimmer ? 2 : products.count
     }else if  tableView == videoTableView {
        return  self.showShimmer ? 2 : video.count
      }else {
          return  self.showShimmer ? 2 : artists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == projectTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! FavouritProjectCell
            if !self.showShimmer{
            cell.priceLbl.isHidden = true
             cell.confic(name: self.projects[indexPath.row].title ?? "", price: "", image: self.projects[indexPath.row].imageURL ?? "")
            cell.removeFavourite = {
                self.favouriteVM.showIndicator()
                self.projectFavourite(id: self.projects[indexPath.row].id ?? 0, Type: false)
                }
            }
            cell.showShimmer = self.showShimmer
            return cell
        }else if tableView == productTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier2) as! FavouritProjectCell
            if !self.showShimmer{
                cell.priceLbl.isHidden = false
                cell.confic(name: self.products[indexPath.row].title ?? "", price:  String(self.products[indexPath.row].price ?? 0), image: self.products[indexPath.row].imageURL ?? "")
                cell.removeFavourite = {
                    self.favouriteVM.showIndicator()
                    self.productFavourite(id: self.products[indexPath.row].id ?? 0, Type: false)
                }
            }
            cell.showShimmer = self.showShimmer
            return cell
            }else  if tableView == videoTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier4) as! FavouritVideoCell
                if !self.showShimmer{
                cell.confic(name: self.video[indexPath.row].title ?? "", price:"", image: self.video[indexPath.row].imageURL ?? "")
                cell.removeFavourite = {
                self.favouriteVM.showIndicator()
                self.addVideoFavourite(videoId:  self.video[indexPath.row].id ?? 0, Type: false)
              }
            }
            cell.showShimmer = self.showShimmer
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier3) as! FavouriteArtistCell
                if !self.showShimmer{
                    cell.confic(name: self.artists[indexPath.row].name ?? "", price: self.artists[indexPath.row].headline ?? "", image: self.artists[indexPath.row].profilPicture ?? "")
                    
                    cell.removeFavourite = {
                        self.favouriteVM.showIndicator()
                        self.artistFavourite(id: self.artists[indexPath.row].id ?? 0, Type: false)

                    }
                }
                cell.showShimmer = self.showShimmer
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if tableView == projectTableView {
           let main = ProjectDetailsVC.instantiateFromNib()
           main!.projectId =  self.projects[indexPath.row].id ?? 0
           self.navigationController?.pushViewController(main!, animated: true)
       }else if tableView == productTableView {
           let vc = ProductDetailsVC.instantiateFromNib()
           vc!.productId = self.products[indexPath.row].id ?? 0
           self.navigationController?.pushViewController(vc!, animated: true)
       }else  if tableView == videoTableView {
           let sb = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "EpisodViewController") as! EpisodViewController
           sb.videoId = self.video[indexPath.row].id ?? 0
           self.navigationController?.pushViewController(sb, animated: true)
       }else if tableView == artistTableView {
           let vc = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProfileVc")  as! ArtistProfileVc
               vc.artistId = self.artists[indexPath.row].id ?? 0
            Helper.saveArtistId(id: self.artists[indexPath.row].id ?? 0)
           self.navigationController?.pushViewController(vc, animated: true)
       }
    }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension FavouriteVc  {

func getFavourite() {
    favouriteVM.getFavourite().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.showShimmer = false
        self.products = dataModel.data?.favoriteProducts ?? []
        self.artists = dataModel.data?.favoriteArtists ?? []
        self.projects = dataModel.data?.favoriteProjects ?? []
        self.video = dataModel.data?.favoriteVideo ?? []
           
        self.artistTableView.reloadData()
        self.projectTableView.reloadData()
        self.productTableView.reloadData()
        self.videoTableView.reloadData()

        if self.artists.count > 0 {
            self.artistView.isHidden = false
        }else{
            self.artistView.isHidden = true
        }
        
        if self.projects.count > 0 {
            self.projectView.isHidden = false
        }else{
            self.projectView.isHidden = true
        }
        if self.products.count > 0 {
            self.productView.isHidden = false
        }else{
            self.productView.isHidden = true
        }
        if self.video.count > 0 {
               self.videoView.isHidden = false
           }else{
               self.videoView.isHidden = true
        }
           
       }
   }, onError: { (error) in

   }).disposed(by: disposeBag)
}
    
    
    func productFavourite(id : Int , Type : Bool) {
        favouriteVM.productFavourite(productId: id, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.favouriteVM.dismissIndicator()
            self.getFavourite()
           }
       }, onError: { (error) in
           self.favouriteVM.dismissIndicator()

       }).disposed(by: disposeBag)
    }
    
    
    func artistFavourite(id : Int , Type : Bool) {
        favouriteVM.artistFavourite(artistId: id, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.favouriteVM.dismissIndicator()
            self.getFavourite()

           }
       }, onError: { (error) in
           self.favouriteVM.dismissIndicator()

       }).disposed(by: disposeBag)
    }
    
    
    
    func projectFavourite(id : Int , Type : Bool) {
        favouriteVM.projectFavourite(productID: id, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.favouriteVM.dismissIndicator()
            self.getFavourite()

           }
       }, onError: { (error) in
           self.favouriteVM.dismissIndicator()

       }).disposed(by: disposeBag)
    }
    
    
    func addVideoFavourite(videoId : Int,Type : Bool) {
        favouriteVM.addVideoFavourite(videoId: videoId, Type: Type).subscribe(onNext: { [self] (dataModel) in
           if dataModel.success ?? false {
            self.favouriteVM.dismissIndicator()
            self.getFavourite()
           }
       }, onError: { (error) in
        self.favouriteVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}
