//
//  CompetitionsVc.swift
//  Mad
//
//  Created by MAC on 23/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class CompetitionsVc: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "CompetitionCell"
    
    
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artistId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        getArtistProfile(artistId : 8825)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension CompetitionsVc : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! CompetitionCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension CompetitionsVc{
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            //self.social = dataModel.data?.socialLinks ?? []
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
