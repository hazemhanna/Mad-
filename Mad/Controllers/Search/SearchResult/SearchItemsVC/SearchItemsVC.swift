//
//  SearchItemsVC.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//



import UIKit
import RxSwift
import RxCocoa

class SearchItemsVC : UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var showShimmer: Bool = true
    var items = [Product](){
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

extension SearchItemsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showShimmer ? 1 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! SearchItemsCell
        if !self.showShimmer{
            
            cell.titleLabel.text = self.items[indexPath.row].title ?? ""
            cell.artistNmaeLabel.text = self.items[indexPath.row].artist?.name ?? ""
            if let bannerUrl = URL(string:   self.items[indexPath.row].imageURL ?? ""){
                cell.bannermage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
            }
            if let artistUrl = URL(string:   self.items[indexPath.row].artist?.bannerImg ?? ""){
            cell.artistImage.kf.setImage(with: artistUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
            
            cell.remove = {
                self.searchVM.showIndicator()
                self.remove(section: "products", objectId: self.items[indexPath.row].id ?? 0)
                self.items.remove(at: indexPath.row)


            }
            
            cell.activeStack.isHidden = true
            cell.artistStack.isHidden = false
        }
        cell.showShimmer = self.showShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addNewVisit(section: "products", objectId: self.items[indexPath.row].id ?? 0)
        let vc = ProductDetailsVC.instantiateFromNib()
        vc!.productId = self.items[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
extension SearchItemsVC{
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
