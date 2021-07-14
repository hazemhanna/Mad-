//
//  BlogsVc.swift
//  Mad
//
//  Created by MAC on 21/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class BlogsVc  : UIViewController {
   
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var catCollectionView: UICollectionView!
    
    var blogsVM = BlogsViewModel()
    var disposeBag = DisposeBag()
    var parentVC : HomeVC?
    var token = Helper.getAPIToken() ?? ""

    var Categories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.catCollectionView.reloadData()
            }
        }
    }
    
    var blogs = [Blog]() {
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
    let cellIdentifier = "ProjectCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        self.catCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
       // getCategory()
       // getProject()
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

extension BlogsVc : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.mainTableView.register(UINib(nibName: self.CellIdentifier, bundle: nil), forCellReuseIdentifier: self.CellIdentifier)
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showShimmer ? 1 : blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as! HomeCell
        if !self.showShimmer {
            cell.confic(name : ""
                        ,date : blogs[indexPath.row].createdAt ?? ""
                        , title : blogs[indexPath.row].title ?? ""
                        , like : 0
                        , share : blogs[indexPath.row].shareCount ?? 0
                        , profileUrl : ""
                        , projectUrl :blogs[indexPath.row].imageURL ?? ""
                        , trustUrl : "", isFavourite: false)
               
            cell.favouriteStack.isHidden = true
             // share project
//            cell.share = {
//                if self.token == ""{
//                    return
//                }
//                self.homeVM.showIndicator()
//                self.shareProject(productID:  self.blogs[indexPath.row].id ?? 0)
//
//                // text to share
//                let text = self.blogs[indexPath.row].title ?? ""
//                let image = self.blogs[indexPath.row].artist?.profilPicture ?? ""
//                let textToShare = [ text ,image]
//                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//                activityViewController.popoverPresentationController?.sourceView = self.view
//              activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
//                self.present(activityViewController, animated: true, completion: nil)
//
//            }
        }
        cell.showShimmer = showProjectShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showProjectShimmer {
            return
        }
        let main = ProjectDetailsVC.instantiateFromNib()
        main!.projectId =  self.blogs[indexPath.row].id!
        self.navigationController?.pushViewController(main!, animated: true)
     
    }
    
}


extension BlogsVc  : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 5 : Categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProjectCell

        if !self.showShimmer {
                cell.catImage.isHidden = false
                cell.addProjectBtn.isHidden = true
                cell.projectNameLabel.text = self.Categories[indexPath.row].name ?? ""
                if let url = URL(string:   self.Categories[indexPath.row].imageURL ?? ""){
                cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Icon - Checkbox - Off"))
                }
        }
        cell.showShimmer = showShimmer
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showShimmer {
            return
        }
    }
}

extension BlogsVc  : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space) / 5
        return CGSize(width: size, height: collectionView.frame.size.height)
    }
}

extension BlogsVc  {
    func getCategory() {
        blogsVM.getCategories().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
               self.Categories = dataModel.data ?? []

           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    func getProject() {
        blogsVM.getBlogs(page: 1, catId: 0).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showProjectShimmer = false
            self.blogs = dataModel.data?.data ?? []
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }

    
//    func shareProject(productID : Int) {
//        blogsVM.shareProject(productID: productID).subscribe(onNext: { (dataModel) in
//           if dataModel.success ?? false {
//            self.homeVM.dismissIndicator()
//            self.getProject()
//            self.showMessage(text: dataModel.message ?? "")
//           }
//       }, onError: { (error) in
//        self.homeVM.dismissIndicator()
//       }).disposed(by: disposeBag)
//   }
}

