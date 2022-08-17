//
//  SearchTagsVC.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SearchTagsVC : UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var showShimmer: Bool = true
    var tags = [Tags](){
        didSet{
            tableView.reloadData()
            showShimmer = false
        }
    }
    var  parentVC: SearchResultVc?

    let cellIdentifier = "TagsCell"
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

extension SearchTagsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showShimmer ? 1 : tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! TagsCell
        if !self.showShimmer{
            cell.titleLabel.text = tags[indexPath.row].name ?? ""
            
            cell.remove = {
                self.searchVM.showIndicator()
                self.remove(section: "tags", objectId: self.tags[indexPath.row].id ?? 0)
                self.tags.remove(at: indexPath.row)

            }
            
        }
        cell.showShimmer = self.showShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
extension SearchTagsVC{
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

           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }

}
