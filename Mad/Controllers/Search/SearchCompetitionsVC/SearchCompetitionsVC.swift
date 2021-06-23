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
    var competitions = [Int](){
        didSet{
            tableView.reloadData()
            showShimmer = false
        }
    }
    var  parentVC: SearchResultVc?

    let cellIdentifier = "SearchItemsCell"
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

extension SearchCompetitionsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showShimmer ? 1 : competitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! SearchItemsCell
        if !self.showShimmer{
            cell.activeStack.isHidden = false
            cell.artistStack.isHidden = true
        }
        cell.showShimmer = self.showShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
