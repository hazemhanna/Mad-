//
//  ProjectBlogVc.swift
//  Mad
//
//  Created by MAC on 17/06/2022.
//

import UIKit
import UIKit
class ProjectBlogVc: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let CellIdentifier = "VideoProjectCell"
    var showShimmer: Bool = true
    var parentVC : BlogDetailsVc?
    var project = [Project](){
        didSet{
            tableView.reloadData()
            showShimmer = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }

}

extension ProjectBlogVc : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.CellIdentifier, bundle: nil), forCellReuseIdentifier: self.CellIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.showShimmer ? 1 : project.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as! VideoProjectCell
        if !self.showShimmer{
            cell.confic(title : project[indexPath.row].title ?? ""
                        , like :project[indexPath.row].favoriteCount ?? 0
                        , share : project[indexPath.row].shareCount ?? 0
                        , projectUrl :project[indexPath.row].imageURL ?? ""
                        , isFavourite: project[indexPath.row].isFavorite ?? false)

            cell.favourite = {
                if Helper.getAPIToken() != nil {
                self.parentVC?.blogsVM.showIndicator()
                    
             if self.project[indexPath.row].isFavorite ?? false{
                self.parentVC?.addProjectToFavourite(projectID:  self.project[indexPath.row].id ?? 0, Type: false)
                self.tableView.reloadData()
                }else{
                    self.parentVC?.addProjectToFavourite(projectID:  self.project[indexPath.row].id ?? 0, Type: true)
                    self.tableView.reloadData()
               }
              }else {
                displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
                let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                if let appDelegate = UIApplication.shared.delegate {
                    appDelegate.window??.rootViewController = sb
                }
                return

              }
            }
        }
        
        cell.favouriteBtn.setImage(UIImage(named:"Group 140"), for: .normal)
        cell.shareBtn.setImage(UIImage(named:"Path 327"), for: .normal)
        cell.backgroundColor = UIColor.white
        cell.titleLbl.textColor =  #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
        cell.LikeLbl.textColor =  #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
        cell.shareLbl.textColor =  #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)

        cell.showShimmer = showShimmer
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = ProjectDetailsVC.instantiateFromNib()
        main!.projectId = self.project[indexPath.row].id!
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
}
