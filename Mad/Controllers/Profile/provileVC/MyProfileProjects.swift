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
  
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var navigate = false
    var showShimmer: Bool = true
    var projects = [Project]()
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
            self.projects = publishProjects
            self.mainTableView.reloadData()
            navigate = true
            if self.projects.count > 0 {
                self.availabeLbl.isHidden = true
            }else{
                self.availabeLbl.isHidden = false
            }
            
        }else{
            publishBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            pendingBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            self.projects = pendingProjects
            self.mainTableView.reloadData()
            navigate = false
            if self.projects.count > 0 {
                self.availabeLbl.isHidden = true
            }else{
                self.availabeLbl.isHidden = false
            }
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
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.showShimmer ? 3 : projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as! HomeCell
        if !self.showShimmer {
        cell.confic(name : projects[indexPath.row].artist?.name ?? "MAD"
                    ,date : projects[indexPath.row].createdAt ?? ""
                    , title : projects[indexPath.row].title ?? ""
                    , like :projects[indexPath.row].favoriteCount ?? 0
                    , share : projects[indexPath.row].shareCount ?? 0
                    , profileUrl : projects[indexPath.row].artist?.profilPicture ?? ""
                    , projectUrl :projects[indexPath.row].imageURL ?? ""
                    , trustUrl : ""
                    , isFavourite: projects[indexPath.row].isFavorite ?? false
                    ,relatedProduct: projects[indexPath.row].relateProducts ?? [])
            
        }
        cell.showShimmer = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navigate {
        let main = ProjectDetailsVC.instantiateFromNib()
        main!.projectId =  self.projects[indexPath.row].id ?? 0
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
            self.projects = dataModel.data?.projects ?? []
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
}

