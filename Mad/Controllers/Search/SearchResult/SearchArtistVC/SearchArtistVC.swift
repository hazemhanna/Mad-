//
//  SearchArtistVC.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SearchArtistVC : UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var showShimmer: Bool = true
    var artists = [Artist](){
        didSet{
            tableView.reloadData()
            showShimmer = false
        }
    }
    
    
    var  parentVC: SearchResultVc?

    let cellIdentifier = "SearchArtistCell"
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

extension SearchArtistVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! SearchArtistCell
            cell.titleLabel.text = self.artists[indexPath.row].name ?? ""
            cell.subTitleLabel.text = self.artists[indexPath.row].headline ?? ""
            if let bannerUrl = URL(string:   self.artists[indexPath.row].profilPicture ?? ""){
            cell.bannermage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
        
        cell.remove = {
            self.searchVM.showIndicator()
            self.remove(section: "artists", objectId: self.artists[indexPath.row].id ?? 0)
            self.artists.remove(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showShimmer {return}
        self.addNewVisit(section: "artists", objectId: self.artists[indexPath.row].id ?? 0)
        let vc = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProfileVc")  as! ArtistProfileVc
            vc.artistId = self.artists[indexPath.row].id ?? 0
            Helper.saveArtistId(id: self.artists[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension SearchArtistVC{
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
