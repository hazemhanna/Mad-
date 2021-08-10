//
//  EditMyProfileVc.swift
//  Mad
//
//  Created by MAC on 09/08/2021.
//


import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

struct socialMedia {
    let icon : UIImage?
    let name : String?
    let url : String?
    
}

class EditMyProfileVc: UIViewController {
    
    @IBOutlet weak var  socialTableview : UITableView!
    @IBOutlet weak var  socialTableviewHieght : NSLayoutConstraint!

    let cellIdentifier = "SocialCell"
    
    var social  = [socialMedia](){
        didSet{
            socialTableviewHieght.constant = CGFloat((40 * self.social.count))
            socialTableview.reloadData()
        }
    }

    var homeVM = HomeViewModel()
    var disposeBag = DisposeBag()
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}



extension EditMyProfileVc : UITableViewDelegate,UITableViewDataSource{
    func setupContentTableView() {
        socialTableview.delegate = self
        socialTableview.dataSource = self
        self.socialTableview.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return social.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! SocialCell
        cell.nameLbl.text = self.social[indexPath.row].name ?? ""
        cell.iconImage.image = self.social[indexPath.row].icon
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

}
