//
//  SearchCompetitionsVC.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//


import UIKit
import RxSwift
import RxCocoa

class SearchCompetitionsVC : UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var showShimmer: Bool = true
    var competitions = [Competitions](){
        didSet{
            tableView.reloadData()
            showShimmer = false
        }
    }
    var  parentVC: SearchResultVc?

    let cellIdentifier = "SearchItemsCell"
    var searchVM = SearchViewModel()
    var disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension SearchCompetitionsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showShimmer ? 1 : competitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! SearchItemsCell
        if !self.showShimmer{
            cell.titleLabel.text = self.competitions[indexPath.row].title ?? ""
            if let bannerUrl = URL(string:   self.competitions[indexPath.row].bannerImg ?? ""){
                cell.bannermage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
            }
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            if let step2End = competitions[indexPath.row].step2End?.toDate(){
                if result.toDate()?.compare(step2End) == ComparisonResult.orderedAscending{
                    cell.activeLabel.text = "active"
                    cell.activeIcon.backgroundColor = #colorLiteral(red: 0, green: 0.8509803922, blue: 0.262745098, alpha: 1)
                }else{
                    cell.activeLabel.text = "Finished"
                    cell.activeIcon.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0, blue: 0, alpha: 1)
                }
            }
            
            cell.remove = {
                self.searchVM.showIndicator()
                self.remove(section: "competitions", objectId: self.competitions[indexPath.row].id ?? 0)
                self.competitions.remove(at: indexPath.row)
            }
            
            cell.activeStack.isHidden = false
            cell.artistStack.isHidden = true
        }
        cell.showShimmer = self.showShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.addNewVisit(section: "competitions", objectId: self.competitions[indexPath.row].id ?? 0)
            let main = CompetitionsDetailsVc.instantiateFromNib()
            main!.compId = self.competitions[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(main!, animated: true)
        }
    }
    
}

extension SearchCompetitionsVC{
    func remove(section : String,objectId:Int) {
        searchVM.removeVisit(section: section, id: objectId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.searchVM.dismissIndicator()
            self.tableView.reloadData()
           }
       }, onError: { (error) in
        self.searchVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    func addNewVisit(section : String,objectId:Int) {
        searchVM.addNewVisit(section: section, id: objectId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            print(dataModel)
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }

    
}
