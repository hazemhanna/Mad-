//
//  ProjectsVC.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ProjectsVC: UIViewController {
   
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    var homeVM = HomeViewModel()
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
    
     var showShimmer: Bool = true
    var showProjectShimmer: Bool = true

    var disposeBag = DisposeBag()
    private let CellIdentifier = "HomeCell"
    let cellIdentifier = "ProjectCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        self.projectCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        projectCollectionView.delegate = self
        projectCollectionView.dataSource = self
        getCategory()
        getProject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension ProjectsVC: UITableViewDelegate,UITableViewDataSource{
    
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
                        , profileUrl : projects[indexPath.row].artist?.imageURL ?? ""
                        , projectUrl :projects[indexPath.row].imageURL ?? ""
                        , trustUrl : "")
        }
            
        cell.showShimmer = showProjectShimmer
        return cell
    }
}


extension ProjectsVC: UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 5 : Categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProjectCell

        if !self.showShimmer {
        if indexPath.row == 0 {
                cell.catImage.isHidden = true
                cell.addProjectBtn.isHidden = false
                cell.projectNameLabel.text = "creat project"
            }else{
                
                cell.catImage.isHidden = false
                cell.addProjectBtn.isHidden = true
                cell.projectNameLabel.text = self.Categories[indexPath.row-1].name ?? ""
                if let url = URL(string:   self.Categories[indexPath.row-1].imageURL ?? ""){
                cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
                }
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

extension ProjectsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: collectionView.frame.size.height)
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
    
    func getProject() {
        homeVM.getAllProject(page: 1).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showProjectShimmer = false
            self.projects = dataModel.data?.projects ?? []
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }

    
}
