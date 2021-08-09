//
//  MyProfileCompetitions.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class MyProfileCompetitions : UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "CompetitionCell"
    var showShimmer = true

    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var competitions = [Competitions]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfile()
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension MyProfileCompetitions : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showShimmer ? 3 : competitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! CompetitionCell
        if !self.showShimmer {
            cell.confic(imageUrl: self.competitions[indexPath.row].bannerImg ?? "", title: self.competitions[indexPath.row].title ?? "", date: ("End Date: ") + (self.competitions[indexPath.row].resultDate ?? ""))

        }
        cell.showShimmer = showShimmer

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension MyProfileCompetitions{
    func getProfile() {
        artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.competitions = dataModel.data?.ongoingCompetitions ?? []
            self.tableView.reloadData()
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
