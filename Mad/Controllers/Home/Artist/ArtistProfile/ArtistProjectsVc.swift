//
//  ArtistProjectsVc.swift
//  Mad
//
//  Created by MAC on 20/04/2021.
//


import UIKit
import RxSwift
import RxCocoa

class ArtistProjectsVc : UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var availableLbl : UILabel!

    
 
    private let CellIdentifier = "HomeCell"
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artistId = Helper.getArtistId() ?? 0
    var token = Helper.getAPIToken() ?? ""

    var showShimmer: Bool = true
    var projects = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getArtistProfile(artistId : artistId)
        self.navigationController?.navigationBar.isHidden = true
    }

    
}

extension ArtistProjectsVc: UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.mainTableView.register(UINib(nibName: self.CellIdentifier, bundle: nil), forCellReuseIdentifier: self.CellIdentifier)
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showShimmer ? 3 : self.projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as! HomeCell
        if !self.showShimmer {
        cell.confic(name : projects[indexPath.row].artist?.name ?? "MAD"
                    ,date : projects[indexPath.row].createdAt ?? ""
                    , title : projects[indexPath.row].title ?? ""
                    , like :projects[indexPath.row].favoriteCount ?? 0
                    , share : projects[indexPath.row].shareCount ?? 0
                    , profileUrl : projects[indexPath.row].artist?.profilPicture ?? ""
                    , projectUrl :projects[indexPath.row].imageURL ?? ""
                    , trustUrl : "", isFavourite: projects[indexPath.row].isFavorite ?? false, relatedProduct:  projects[indexPath.row].relateProducts ?? [])
            
            
            // edit favourite
              cell.favourite = {
                if self.token == "" {
                    displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
                    let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                    if let appDelegate = UIApplication.shared.delegate {
                        appDelegate.window??.rootViewController = sb
                    }
                    return
                }
                self.artistVM.showIndicator()
                if  self.projects[indexPath.row].isFavorite ?? false {
                    self.editFavourite(productID:  self.projects[indexPath.row].id ?? 0, Type: false)
                }else{
                  self.editFavourite(productID:  self.projects[indexPath.row].id ?? 0, Type: true)
                }
             }
            cell.favouriteStack.isHidden = false
             // share project
            cell.share = {
                if self.token == "" {
                    displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
                    let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                    if let appDelegate = UIApplication.shared.delegate {
                        appDelegate.window??.rootViewController = sb
                    }
                    return
                }
                self.artistVM.showIndicator()
                self.shareProject(productID:  self.projects[indexPath.row].id ?? 0)

                // text to share
                let text = self.projects[indexPath.row].title ?? ""
                let image = self.projects[indexPath.row].artist?.profilPicture ?? ""
                let textToShare = [ text ,image]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
              activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                self.present(activityViewController, animated: true, completion: nil)

            }
        }
        cell.showShimmer = showShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = ProjectDetailsVC.instantiateFromNib()
        main!.projectId =  self.projects[indexPath.row].id!
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
}


extension ArtistProjectsVc  {
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.projects = dataModel.data?.projects ?? []
            self.mainTableView.reloadData()

            if dataModel.data?.projects?.count ?? 0  > 0 {
                self.mainTableView.isHidden = false
                self.availableLbl.isHidden = true

            }else{
                self.mainTableView.isHidden = true
                self.availableLbl.isHidden = false
            }
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    func editFavourite(productID : Int,Type : Bool) {
        artistVM.addToFavouriteProject(productID: productID, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.getArtistProfile(artistId : self.artistId)
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }

    func shareProject(productID : Int) {
        artistVM.shareProject(productID: productID).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artistVM.dismissIndicator()
            self.getArtistProfile(artistId : self.artistId)
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}
