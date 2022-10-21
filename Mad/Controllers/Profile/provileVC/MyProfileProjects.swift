//
//  MyProfileProjects.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//



import UIKit
import RxSwift
import RxCocoa

class MyProfileProjects : UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var draftLbl: UILabel!
    @IBOutlet weak var availabeLbl : UILabel!
    
    private let CellIdentifier = "HomeCell"
    private let CellIdentifier2 = "PuplishedProjectTableViewCell"

    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var navigate = true
    var showShimmer: Bool = true
    //var projects = [Project]()
    var publishProjects = [Project]()
    var pendingProjects = [Project]()
    var draftProjects = [Project]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfile()
        self.navigationController?.navigationBar.isHidden = true
        pendingBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
        publishBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
    }
    
    @IBAction func addProjectButton(sender: UIButton) {
        let vc = AddProjectdetailsVc.instantiateFromNib()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func pendingBtn(sender: UIButton) {
        if sender.tag == 0 {
            pendingBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            publishBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            //self.projects = publishProjects
            navigate = true
            if self.publishProjects.count > 0 {
                self.availabeLbl.isHidden = true
            }else{
                self.availabeLbl.isHidden = false
            }
            self.mainTableView.reloadData()

        }else{
            publishBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            pendingBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
           // self.projects = pendingProjects
            navigate = false
            if self.pendingProjects.count > 0 {
                self.availabeLbl.isHidden = true
            }else{
                self.availabeLbl.isHidden = false
            }
            self.mainTableView.reloadData()

        }
    }
    
    @IBAction func draftBtn(sender: UIButton) {
    let main = DraftsVc.instantiateFromNib()
    main?.projects = draftProjects
    main?.draftType = "project"
    self.navigationController?.pushViewController(main!, animated: true)
    }
    
}

extension MyProfileProjects: UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.mainTableView.register(UINib(nibName: self.CellIdentifier, bundle: nil), forCellReuseIdentifier: self.CellIdentifier)
        self.mainTableView.register(UINib(nibName: self.CellIdentifier2, bundle: nil), forCellReuseIdentifier: self.CellIdentifier2)
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if navigate{
        return  publishProjects.count
        }else{
            return  self.showShimmer ? 3 : pendingProjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if navigate {
         let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier2) as! PuplishedProjectTableViewCell
            cell.confic(projectUrl: publishProjects[indexPath.row].imageURL ?? ""
                        , name: publishProjects[indexPath.row].title ?? ""
                        , price: "40 USD  | 40 EURO"
                        , view: "0"
                        , orders: "0")
            
            cell.hideProject = {
                self.showProject(id: self.publishProjects[indexPath.row].id ?? 0 ,hide : 1)
            }
            cell.showProject = {
                self.showProject(id: self.publishProjects[indexPath.row].id ?? 0 ,hide : 0)
            }
            if self.publishProjects[indexPath.row].hide == "0"{
                cell.hideSwitch.isOn = false
            }else{
                cell.hideSwitch.isOn = true
            }
            return cell
      }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as! HomeCell
        if !self.showShimmer {
        cell.confic(name : pendingProjects[indexPath.row].artist?.name ?? "MAD"
                    ,date : pendingProjects[indexPath.row].createdAt ?? ""
                    , title : pendingProjects[indexPath.row].title ?? ""
                    , like :pendingProjects[indexPath.row].favoriteCount ?? 0
                    , share : pendingProjects[indexPath.row].shareCount ?? 0
                    , profileUrl : pendingProjects[indexPath.row].artist?.profilPicture ?? ""
                    , projectUrl :pendingProjects[indexPath.row].imageURL ?? ""
                    , trustUrl : ""
                    , isFavourite: pendingProjects[indexPath.row].isFavorite ?? false
                    ,relatedProduct: pendingProjects[indexPath.row].relateProducts ?? [])
            
        }
        cell.showShimmer = false
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navigate {
        let main = ProjectDetailsVC.instantiateFromNib()
        main!.projectId =  self.publishProjects[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(main!, animated: true)
        }else{
//            let vc = AddProjectdetailsVc.instantiateFromNib()
//            vc?.projectId = pendingProjects[indexPath.row].id ?? 0
//            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
extension MyProfileProjects  {
    func getProfile() {
        artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer  = false
            self.publishProjects = dataModel.data?.projects ?? []
            self.pendingProjects = dataModel.data?.pendingProjects ?? []
            self.draftProjects = dataModel.data?.draftProjects ?? []
            self.pendingBtn.setTitle("Pending [\(self.pendingProjects.count)]", for: .normal)
            self.draftLbl.text = "All Drafts [\(dataModel.data?.draftProjects?.count ?? 0)]"
            self.mainTableView.reloadData()
            
               if dataModel.data?.projects?.count ?? 0 > 0 {
                self.availabeLbl.isHidden = true
            }else{
                self.availabeLbl.isHidden = false
            }
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    func showProject(id : Int,hide : Int) {
        artistVM.showIndicator()
        artistVM.hideProject(id: id, hide: hide).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
               self.artistVM.dismissIndicator()
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
}

