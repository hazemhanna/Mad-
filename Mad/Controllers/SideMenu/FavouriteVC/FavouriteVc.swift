//
//  FavouriteVc.swift
//  Mad
//
//  Created by MAC on 09/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class FavouriteVc: UIViewController {
    
    @IBOutlet weak var projectTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var artistTableView: UITableView!
    
    let cellIdentifier = "FavouritProjectCell"
    let cellIdentifier2 = "FavouritProjectCell"
    let cellIdentifier3 = "FavouriteArtistCell"
    
    var showShimmer: Bool = false
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension FavouriteVc  : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        artistTableView.delegate = self
        artistTableView.dataSource = self
    
        self.artistTableView.register(UINib(nibName: self.cellIdentifier3, bundle: nil), forCellReuseIdentifier: self.cellIdentifier3)

        
        productTableView.delegate = self
        productTableView.dataSource = self
        
        self.productTableView.register(UINib(nibName: self.cellIdentifier2, bundle: nil), forCellReuseIdentifier: self.cellIdentifier2)

        projectTableView.delegate = self
        projectTableView.dataSource = self
        self.projectTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
       

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     if tableView == projectTableView {
        return 2
     }else if tableView == productTableView {
        return 2
     }else {
         return 2
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == projectTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! FavouritProjectCell
            if !self.showShimmer{
                cell.priceLbl.isHidden = true
            }
            cell.showShimmer = self.showShimmer

            return cell
        }else if tableView == productTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier2) as! FavouritProjectCell
            if !self.showShimmer{
                cell.priceLbl.isHidden = false

            }
            cell.showShimmer = self.showShimmer
            return cell
            }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier3) as! FavouriteArtistCell
                if !self.showShimmer{
               
                }
                cell.showShimmer = self.showShimmer
            return cell
        }
    }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
