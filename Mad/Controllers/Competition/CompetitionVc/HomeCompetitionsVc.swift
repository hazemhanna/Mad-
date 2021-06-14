//
//  HomeCompetitionsVc.swift
//  Mad
//
//  Created by MAC on 09/06/2021.
//



import UIKit
import RxSwift
import RxCocoa

class HomeCompetitionsVc : UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "CompetitionCell"
    var parentVC : HomeVC?

    
    var competitionVm = CometitionsViewModel()
    var disposeBag = DisposeBag()
    var artistId = Int()
    var showShimmer: Bool = true
    var competitions = [Competitions]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension HomeCompetitionsVc : UITableViewDelegate,UITableViewDataSource{
    
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
            cell.confic(imageUrl: self.competitions[indexPath.row].bannerImg ?? "", title: self.competitions[indexPath.row].title ?? "", date: self.competitions[indexPath.row].resultDate ?? "")
        }
        cell.showShimmer = showShimmer

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = CompetitionsDetailsVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
}

extension HomeCompetitionsVc{
    func getProject(search : String,step:String,pageNum :Int) {
        competitionVm.getAllCompetions(search: search, step: step, pageNum: pageNum).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.competitions = dataModel.data?.data ?? []
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
}