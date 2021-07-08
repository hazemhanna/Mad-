//
//  MyProfileProjects.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//

import Foundation
//
//  ArtistProjectsVc.swift
//  Mad
//
//  Created by MAC on 20/04/2021.
//


import UIKit
import RxSwift
import RxCocoa

class MyProfileProjects : UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    private let CellIdentifier = "HomeCell"
  

    var showShimmer: Bool = false
    var projects = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension MyProfileProjects: UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.mainTableView.register(UINib(nibName: self.CellIdentifier, bundle: nil), forCellReuseIdentifier: self.CellIdentifier)
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as! HomeCell
//        if !self.showShimmer {
//        cell.confic(name : projects[indexPath.row].artist?.name ?? "MAD"
//                    ,date : projects[indexPath.row].createdAt ?? ""
//                    , title : projects[indexPath.row].title ?? ""
//                    , like :projects[indexPath.row].favoriteCount ?? 0
//                    , share : projects[indexPath.row].shareCount ?? 0
//                    , profileUrl : projects[indexPath.row].artist?.profilPicture ?? ""
//                    , projectUrl :projects[indexPath.row].imageURL ?? ""
//                    , trustUrl : "", isFavourite: projects[indexPath.row].isFavorite ?? false)
//        }
        cell.showShimmer = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
