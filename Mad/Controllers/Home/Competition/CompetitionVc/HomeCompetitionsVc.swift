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
    @IBOutlet weak var selectCompDropDown: TextFieldDropDown!
    @IBOutlet weak var searchBar: UITextField!

    let cellIdentifier = "CompetitionCell"
    var parentVC : HomeVC?
    var comp = ["all","ongoing","complete"]
    var compValue = "ongoing"
    var competitionVm = CometitionsViewModel()
    var disposeBag = DisposeBag()
    var artistId = Int()
    var showShimmer: Bool = true
    var competitions = [Competitions]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        setupCopDropDown()
        searchBar.addTarget(self, action: #selector(HomeCompetitionsVc.textFieldDidChange(_:)), for: .editingChanged)
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCompetitions(search: "", step: self.compValue, pageNum: 1)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupCopDropDown(){
        selectCompDropDown.optionArray = self.comp
        selectCompDropDown.didSelect { (selectedText, index, id) in
            self.selectCompDropDown.text = selectedText
            self.compValue = self.comp[index]
            self.getCompetitions(search: "", step: self.compValue, pageNum: 1)
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
