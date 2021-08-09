//
//  MyProfileAbout.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//



import UIKit
import RxSwift
import RxCocoa

class MyProfileAbout : UIViewController {

    @IBOutlet weak var  levelLbl: UILabel!
    @IBOutlet weak var  pointLbl: UILabel!
    @IBOutlet weak var  bioLbL : UILabel!
    @IBOutlet weak var  socialTableview : UITableView!
    let cellIdentifier = "SocialCell"
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()

    var social  = [Social]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfile()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func editProfile(sender: UIButton) {
        let vc = EditMyProfileVc.instantiateFromNib()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}


extension MyProfileAbout : UITableViewDelegate,UITableViewDataSource{
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
        cell.confic(name : self.social[indexPath.row].name ?? "" ,icon : self.social[indexPath.row].icon ?? "")
        cell.details = {
            if let url = self.social[indexPath.row].url {
            Helper.UIApplicationURL.openUrl(url: url)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

}

extension MyProfileAbout  {
    func getProfile() {
        artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.bioLbL.text = dataModel.data?.about ?? ""
            self.pointLbl.text = "\(dataModel.data?.points ?? 0)"
            self.levelLbl.text = dataModel.data?.level ?? ""
            self.social = dataModel.data?.socialLinks ?? []
            self.socialTableview.reloadData()
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
