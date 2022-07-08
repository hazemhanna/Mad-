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
    @IBOutlet weak var availableLbl : UILabel!

    
    let cellIdentifier = "CompetitionCell"
    var artistId = Helper.getArtistId() ?? 0
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var showShimmer: Bool = true
    var competitions = [Competitions](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        getArtistProfile(artistId : artistId)

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let main = CompetitionsDetailsVc.instantiateFromNib()
            main!.compId = self.competitions[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(main!, animated: true)
        }
    }
    
}

extension CompetitionsVc{
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { [self] (dataModel) in
           if dataModel.success ?? false {
               self.showShimmer = false
               self.competitions = dataModel.data?.completedCompetitions ?? []
               
               if dataModel.data?.completedCompetitions?.count ?? 0  > 0 {
                   self.tableView.isHidden = false
                   self.availableLbl.isHidden = true

               }else{
                   self.tableView.isHidden = true
                   self.availableLbl.isHidden = false
               }

               
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
