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
    var active = Helper.getIsActive() ?? false

    var selectedIndex = -1
    var page = 1
    var isFatching = true
    var catId = Int()
    var selectTwice = false

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

        self.catCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
        setupContentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
        }
        getCategory()
        getBlogs(catId : catId, page: page)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension BlogsVc : UITableViewDelegate,UITableViewDataSource , UITableViewDataSourcePrefetching{
    
    func setupContentTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.prefetchDataSource = self
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
            cell.confic(name : blogs[indexPath.row].title ?? "" ,
                        date : blogs[indexPath.row].createdAt ?? "",
                        title: blogs[indexPath.row].content?.html2String ?? "",
                        share: blogs[indexPath.row].shareCount ?? 0,
                        projectUrl: blogs[indexPath.row].imageURL ?? "",
                        relatedProduct : blogs[indexPath.row].relateProducts ?? [] )
            cell.favouriteStack.isHidden = true
            cell.profileImage.isHidden = true
            
            cell.share = {
                if self.token == ""{
                    return
                    
                }
                self.blogsVM.showIndicator()
                self.shareBlogs(blogsId: self.blogs[indexPath.row].id ?? 0)
                let text = self.blogs[indexPath.row].title?.html2String ?? ""
                let image = self.blogs[indexPath.row].imageURL ?? ""
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
        if showProjectShimmer {return}
        let main = BlogDetailsVc.instantiateFromNib()
        main!.blogId =  self.blogs[indexPath.row].id ?? 0 
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= (blogs.count) - 2  && isFatching{
                getBlogs(catId: self.catId,page : self.page)
                isFatching = false
                break
            }
        }
    }

    
    
}


extension BlogsVc  : UICollectionViewDelegate ,UICollectionViewDataSource {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showShimmer {return}
      
            if self.selectedIndex == indexPath.row {
                self.selectedIndex = indexPath.row
                self.catCollectionView.reloadData()
                self.page = 1
                self.blogs.removeAll()
                self.showProjectShimmer = true
                self.mainTableView.reloadData()
                self.selectTwice = true
                getBlogs(catId: 0, page: page)
            }else{
                self.selectedIndex = indexPath.row
                self.catCollectionView.reloadData()
                self.page = 1
                self.blogs.removeAll()
                self.showProjectShimmer = true
                self.mainTableView.reloadData()
                self.selectTwice = false
                self.catId  = self.Categories[indexPath.row].id ?? 0
                getBlogs(catId:self.Categories[indexPath.row].id ?? 0, page: page)
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
    
    func getBlogs(catId : Int,page : Int) {
        blogsVM.getBlogs(page: page, catId: catId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showProjectShimmer = false
            self.blogs.append(contentsOf: dataModel.data?.data ?? [])
            if  self.page < dataModel.data?.countPages ?? 0 && !self.isFatching{
                self.isFatching = true
                self.page += 1
            }
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }

    
    func shareBlogs(blogsId : Int) {
        blogsVM.shareBlogs(blogsId: blogsId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.blogsVM.dismissIndicator()
            self.getBlogs(catId: self.catId, page: self.page)
            self.showMessage(text: dataModel.message ?? "")
           }else{
            self.blogsVM.dismissIndicator()

           }
       }, onError: { (error) in
        self.blogsVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}

