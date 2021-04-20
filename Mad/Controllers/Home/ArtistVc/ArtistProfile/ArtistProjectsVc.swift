//
//  ArtistProjectsVc.swift
//  Mad
//
//  Created by MAC on 20/04/2021.
//


import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class ArtistProjectsVc : UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var homeVM = HomeViewModel()
    var disposeBag = DisposeBag()
    var projects = [Project]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView?.reloadData()
            }
        }
    }
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    
     var showShimmer: Bool = true
    var showProjectShimmer: Bool = true
    private let CellIdentifier = "HomeCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        getProject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
        return self.showShimmer ? 1 : projects.count
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
                        , trustUrl : "", isFavourite: projects[indexPath.row].isFavorite ?? false)
            
            // edit favourite
              cell.favourite = {
                if Helper.getAPIToken() == "" {
                    return
                }
                self.homeVM.showIndicator()
                if  self.projects[indexPath.row].isFavorite ?? false {
                    self.editFavourite(productID:  self.projects[indexPath.row].id ?? 0, Type: false)
                }else{
                  self.editFavourite(productID:  self.projects[indexPath.row].id ?? 0, Type: true)
                }
             }
             // share project
            cell.share = {
                if Helper.getAPIToken() == "" {
                    return
                }
                self.homeVM.showIndicator()
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
        cell.showShimmer = showProjectShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = ProjectDetailsVC.instantiateFromNib()
        main!.projectId =  self.projects[indexPath.row].id!
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
}

extension ArtistProjectsVc {
    
    func getProject() {
        homeVM.getAllProject(page: 1).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showProjectShimmer = false
            self.projects = dataModel.data?.projects ?? []
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }

    func editFavourite(productID : Int,Type : Bool) {
        homeVM.addToFavourite(productID: productID, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.homeVM.dismissIndicator()
            self.getProject()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.homeVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    
    
    func shareProject(productID : Int) {
        homeVM.shareProject(productID: productID).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.homeVM.dismissIndicator()
            self.getProject()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.homeVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}
