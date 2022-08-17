//
//  File.swift
//  Mad
//
//  Created by MAC on 14/09/2021.
//

import Foundation
//
//  ProjectsVC.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar
import Gallery



class ProjectsVC : UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var projectCollectionView: UICollectionView!
    @IBOutlet weak var topCollectionView: UICollectionView!


    var homeVM = HomeViewModel()
    var disposeBag = DisposeBag()
    var parentVC : HomeVC?
    var token = Helper.getAPIToken() ?? ""
    var type = Helper.getType() ?? false
    var active = Helper.getIsActive() ?? false
    var selectedIndex = -1
    var catId = Int()
    var selectTwice = false
    var page = 1
    var isFatching = true

    var Categories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.projectCollectionView.reloadData()
            }
        }
    }

    var projects = [Project]() {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView?.reloadData()
            }
        }
    }

    var topProjects = [Project]() {
        didSet {
            DispatchQueue.main.async {
                self.topCollectionView?.reloadData()
            }
        }
    }


    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()


    var showShimmer: Bool = true
    var showProjectShimmer: Bool = true
    var topShowShimmer: Bool = true

    private let CellIdentifier = "HomeCell"
    private  let cellIdentifier = "ProjectCell"
    private let cellId = "TopProjectCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()

        self.projectCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        projectCollectionView.delegate = self
        projectCollectionView.dataSource = self

        self.topCollectionView.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        topCollectionView.delegate = self
        topCollectionView.dataSource = self

        getCategory()
        getProject(catId: self.catId, page: page)
        getTopProject(page: 1, top: 1)


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


extension ProjectsVC : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == projectCollectionView {
        if active {
            return  self.showShimmer ? 5 : Categories.count + 1
        }else{
            return  self.showShimmer ? 5 : Categories.count
        }
        }else{
            return  self.topShowShimmer ? 2 : topProjects.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == projectCollectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProjectCell
        if !self.showShimmer {
        if active {
           if indexPath.row == 0 {
                cell.catImage.isHidden = true
                cell.addProjectBtn.isHidden = false
            cell.projectNameLabel.text = "Creat.project".localized
             }else{
                 cell.catImage.isHidden = false
                cell.addProjectBtn.isHidden = true
                cell.projectNameLabel.text = self.Categories[indexPath.row-1].name ?? ""
                if let url = URL(string:   self.Categories[indexPath.row-1].imageURL ?? ""){
                cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Icon - Checkbox - Off"))
                }
            }
            }else{
                cell.catImage.isHidden = false
                cell.addProjectBtn.isHidden = true
                cell.projectNameLabel.text = self.Categories[indexPath.row].name ?? ""
                if let url = URL(string:   self.Categories[indexPath.row].imageURL ?? ""){
                cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Icon - Checkbox - Off"))
                }
            }
            cell.add = {
                if self.token != "" {
                    let vc = AddProjectdetailsVc.instantiateFromNib()
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                else{
                    displayMessage(title: "",message: "please login first".localized, status: .error, forController: self)
                    let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                    if let appDelegate = UIApplication.shared.delegate {
                        appDelegate.window??.rootViewController = sb
                    }
                    return
                }

            }

            if self.selectedIndex == indexPath.row{
                if self.selectTwice {
                    cell.ProjectView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1).cgColor
                    cell.ProjectView.layer.borderWidth = 0
                }else{
                    cell.ProjectView.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1).cgColor
                    cell.ProjectView.layer.borderWidth = 2
                }
            }else {
                cell.ProjectView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1).cgColor
                cell.ProjectView.layer.borderWidth = 0
               }
            
        }
        cell.showShimmer = showShimmer
        return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TopProjectCell
            if !self.topShowShimmer {
                let isoDate = topProjects[indexPath.row].createdAt ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from:isoDate)!
                let time = date.getElapsedInterval()
                
                cell.confic(name: topProjects[indexPath.row].artist?.name ?? "MAD"
                            , date: time 
                            , title:  topProjects[indexPath.row].title ?? ""
                            , projectUrl: topProjects[indexPath.row].imageURL ?? ""
                            , profile: topProjects[indexPath.row].artist?.profilPicture ?? "")
                
            }
            cell.showShimmer = topShowShimmer
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if showShimmer {return}
        if collectionView == projectCollectionView {

        if active {
        if indexPath.row != 0 {
            if  self.selectedIndex == indexPath.row {
                self.selectedIndex = indexPath.row
                self.projectCollectionView.reloadData()
                self.projects.removeAll()
                self.page = 1
                self.showProjectShimmer = true
                self.mainTableView.reloadData()
                self.selectTwice = true
                getProject(catId : 0, page: page)

                }else{
                self.selectedIndex = indexPath.row
                self.projectCollectionView.reloadData()
                self.showProjectShimmer = true
                self.projects.removeAll()
                self.page = 1
                self.mainTableView.reloadData()
                self.selectTwice = false
                self.catId  = self.Categories[indexPath.row-1].id ?? 0
                getProject(catId:self.Categories[indexPath.row-1].id ?? 0, page: page)
            }
        }
        }else{
            if self.selectedIndex == indexPath.row {
                self.selectedIndex = indexPath.row
                self.projectCollectionView.reloadData()
                self.projects.removeAll()
                self.page = 1
                self.showProjectShimmer = true
                self.mainTableView.reloadData()
                self.selectTwice = true
                getProject(catId : 0, page: page)
            }else{
                self.selectedIndex = indexPath.row
                self.projectCollectionView.reloadData()
                self.projects.removeAll()
                self.page = 1
                self.showProjectShimmer = true
                self.mainTableView.reloadData()
                self.selectTwice = false
                self.catId  = self.Categories[indexPath.row].id ?? 0
                getProject(catId:self.Categories[indexPath.row].id ?? 0, page: page)
            }
        }
        }else{
            if topShowShimmer {return}
            let main = ProjectDetailsVC.instantiateFromNib()
            main!.projectId =  self.topProjects[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(main!, animated: true)
        }

    }

}

extension ProjectsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)

        if collectionView == projectCollectionView{
        let size:CGFloat = (collectionView.frame.size.width - space) / 5
        return CGSize(width: size, height: collectionView.frame.size.height)
       }else {
      let size:CGFloat = (collectionView.frame.size.width - space) / 1.4
          return CGSize(width: size, height: (collectionView.frame.size.height))
       }
    }
}

extension ProjectsVC: UITableViewDelegate,UITableViewDataSource ,UITableViewDataSourcePrefetching{

    func setupContentTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.prefetchDataSource = self
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
        }
        cell.deleget = self
        cell.showShimmer = showProjectShimmer
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showProjectShimmer {return}
        let main = ProjectDetailsVC.instantiateFromNib()
        main!.projectId =  self.projects[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(main!, animated: true)
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= (projects.count) - 2  && isFatching{
                getProject(catId: self.catId,page : self.page)
                isFatching = false
                break
            }
        }
    }

}



extension ProjectsVC {

    func getCategory() {
        homeVM.getCategories().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
               self.Categories = dataModel.data ?? []
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }

    func getProject(catId : Int,page:Int) {
        homeVM.getProject(page: page,catId: catId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showProjectShimmer = false
            self.projects.append(contentsOf: dataModel.data?.data ?? [])
            if  self.page < dataModel.data?.countPages ?? 0 && !self.isFatching{
                self.isFatching = true
                self.page += 1
            }
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }



    func getTopProject(page:Int,top : Int) {
        homeVM.getTopProject(page: page,top: top).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.topShowShimmer = false
            self.topProjects = dataModel.data?.data ?? []
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }



    func editFavourite(productID : Int,Type : Bool) {
        homeVM.addToFavourite(productID: productID, Type: Type).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.homeVM.dismissIndicator()
            self.getProject(catId: self.catId, page: self.page)
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
            self.getProject(catId: self.catId, page: self.page)
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)

           }
       }, onError: { (error) in
        self.homeVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}
