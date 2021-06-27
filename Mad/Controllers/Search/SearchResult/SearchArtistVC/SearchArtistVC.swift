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
    var artistVM = ArtistViewModel()
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
        return self.showShimmer ? 3 : artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! SearchArtistCell
//        if !self.showShimmer{
//            cell.titleLabel.text = self.artists[indexPath.row].name ?? ""
//            cell.subTitleLabel.text = self.artists[indexPath.row].headline ?? ""
//            if let bannerUrl = URL(string:   self.artists[indexPath.row].bannerImg ?? ""){
//            cell.bannermage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
//           }
//        }
        cell.showShimmer = self.showShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
