//
//  DraftsVc.swift
//  Mad
//
//  Created by MAC on 29/09/2021.
//



import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar
import Gallery


class DraftsVc  : UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    var homeVM = HomeViewModel()
    var disposeBag = DisposeBag()
    var token = Helper.getAPIToken() ?? ""
    var type = Helper.getType() ?? false
    var active = Helper.getIsActive() ?? false
    var draftType = String()
    var projects = [Project]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView?.reloadData()
            }
        }
    }
    var competitions = [Competitions](){
        didSet {
            DispatchQueue.main.async {
                self.mainTableView?.reloadData()
            }
        }
    }

    var products = [Product](){
        didSet {
            DispatchQueue.main.async {
                self.mainTableView?.reloadData()
            }
        }
    }

    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    private let CellIdentifier = "HomeCell"
    let cellIdentifier = "CompetitionCell"
    private let cellId = "TopProjectCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.mainTableView.reloadData()
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DraftsVc: UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self

        self.mainTableView.register(UINib(nibName: self.CellIdentifier, bundle: nil), forCellReuseIdentifier: self.CellIdentifier)
        
        self.mainTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if draftType == "project" {
            return projects.count
        }else if draftType == "competition"{
            return 3
        }else{
            return products.count
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if draftType == "project" {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as! HomeCell

        cell.confic(name : projects[indexPath.row].artist?.name ?? "MAD"
                        ,date : projects[indexPath.row].createdAt ?? ""
                        , title : projects[indexPath.row].title ?? ""
                        , like :projects[indexPath.row].favoriteCount ?? 0
                        , share : projects[indexPath.row].shareCount ?? 0
                        , profileUrl : projects[indexPath.row].artist?.profilPicture ?? ""
                        , projectUrl :projects[indexPath.row].imageURL ?? ""
                        , trustUrl : "", isFavourite: projects[indexPath.row].isFavorite ?? false,relatedProduct: projects[indexPath.row].relateProducts ?? [])


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
                self.homeVM.showIndicator()
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
        cell.showShimmer = false
        return cell
        }else if draftType == "competition"{
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! CompetitionCell
                //cell.confic(imageUrl: self.competitions[indexPath.row].bannerImg ?? "", title: self.competitions[indexPath.row].title ?? "", date: ("End Date: ") + (self.competitions[indexPath.row].resultDate ?? ""))

            
            cell.showShimmer = false

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! CompetitionCell
                cell.confic(imageUrl: self.competitions[indexPath.row].bannerImg ?? "", title: self.competitions[indexPath.row].title ?? "", date: ("End Date: ") + (self.competitions[indexPath.row].resultDate ?? ""))

            
            cell.showShimmer = false
            return cell

        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = ProjectDetailsVC.instantiateFromNib()
        main!.projectId =  self.projects[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(main!, animated: true)
    }
   
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
}

extension DraftsVc {
    
    func editFavourite(productID : Int,Type : Bool) {
        homeVM.addToFavourite(productID: productID, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.homeVM.dismissIndicator()
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)

           }
       }, onError: { (error) in
        self.homeVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }

    func shareProject(productID : Int) {
        homeVM.shareProject(productID: productID).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.homeVM.dismissIndicator()
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)
           }
       }, onError: { (error) in
        self.homeVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}
