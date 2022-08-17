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
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var ongoingBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!

    @IBOutlet weak var searchBar: UITextField!

    let cellIdentifier = "CompetitionCell"
    var parentVC : HomeVC?
    
    var compValue = "all"
    
    var competitionVm = CometitionsViewModel()
    var disposeBag = DisposeBag()
    var artistId = Int()
    var showShimmer: Bool = true
    var competitions = [Competitions]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        searchBar.addTarget(self, action: #selector(HomeCompetitionsVc.textFieldDidChange(_:)), for: .editingChanged)
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCompetitions(search: "", step: self.compValue, pageNum: 1)
        self.navigationController?.navigationBar.isHidden = true
    }
    

    @IBAction func fillterBtn(sender: UIButton) {
        if sender.tag == 0 {
            allBtn.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1), for: .normal)
            ongoingBtn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            completeBtn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            self.getCompetitions(search: "", step: "all", pageNum: 1)
             compValue = "all"

        }else if sender.tag == 1 {
            ongoingBtn.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1), for: .normal)
            allBtn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            completeBtn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            self.getCompetitions(search: "", step: "ongoing", pageNum: 1)
             compValue = "ongoing"

        }else{
            completeBtn.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1), for: .normal)
            ongoingBtn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            allBtn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            self.getCompetitions(search: "", step: "complete", pageNum: 1)
             compValue = "complete"

        }
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

extension HomeCompetitionsVc{
    func getCompetitions(search : String,step:String,pageNum :Int) {
        competitionVm.getAllCompetions(search: search, step: step, pageNum: pageNum).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.competitions = dataModel.data?.data ?? []
            self.tableView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
}

extension HomeCompetitionsVc :UITextFieldDelegate{
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.getCompetitions(search: textField.text ?? "" , step: self.compValue, pageNum: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
