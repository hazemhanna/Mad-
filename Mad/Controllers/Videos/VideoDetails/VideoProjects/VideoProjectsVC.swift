//
//  VideoProjectsVC.swift
//  Mad
//
//  Created by MAC on 19/05/2021.
//



import UIKit
class VideoProjectsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let CellIdentifier = "VideoProjectCell"
    var showShimmer: Bool = true
    var parentVC : VideoDetailsVc?
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

extension VideoProjectsVC : UITableViewDelegate,UITableViewDataSource{
    
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
            
        }
        cell.showShimmer = showShimmer
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    
}
