//
//  CompetitionResultslistsVC.swift
//  Mad
//
//  Created by MAC on 18/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class CompetitionResultslistsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultView : UIView!
    @IBOutlet weak var resultView2 : UIView!

    
    @IBOutlet weak var finalListBtn : UIButton!
    @IBOutlet weak var shortListBtn : UIButton!
    @IBOutlet weak var totalLbl : UILabel!
    @IBOutlet weak var winnerImage : UIImageView!
    @IBOutlet weak var winnerName : UILabel!
    @IBOutlet weak var titlelLbl : UILabel!

    private let cellIdentifier = "CompetitionsResultCell"
    var competitionVm = CometitionsViewModel()
    var disposeBag = DisposeBag()
    
    var showShimmer: Bool = false
    var result = false
    var finalList = [Winner]()
    var shortList = [Winner]()
    var candidate = [Winner]()
    var winner : Winner?
    var final = true
    var titleCompetitions = String()
    var totalVote = Int()
    var compId = Int()
  
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        totalLbl.text = "\(totalVote) votes"
        titlelLbl.text = titleCompetitions
        winnerName.text = winner?.name ?? ""
        if  let winnerImage = URL(string: winner?.imageURL ?? ""){
        self.winnerImage.kf.setImage(with: winnerImage, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
        if result{
            resultView.isHidden = false
            resultView2.isHidden = false
        }else{
            resultView.isHidden = true
            resultView2.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = false
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func listButton(sender: UIButton) {
        if sender.tag == 1{
            finalListBtn.layer.borderWidth = 1
            self.finalListBtn.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1), for: .normal)
            self.finalListBtn.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            shortListBtn.layer.borderWidth = 0
            self.shortListBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            self.shortListBtn.layer.borderColor = UIColor.clear.cgColor
            self.final = true
            self.tableView.reloadData()
        }else{
            shortListBtn.layer.borderWidth = 1
            self.shortListBtn.setTitleColor(#colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1), for: .normal)
            self.shortListBtn.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            finalListBtn.layer.borderWidth = 0
            self.finalListBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            self.finalListBtn.layer.borderColor = UIColor.clear.cgColor
            self.final = false
            self.tableView.reloadData()
        }
    }
    
}

extension CompetitionResultslistsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if result{
        if self.final {
            return self.showShimmer ? 1 : finalList.count
        }else{
            return self.showShimmer ? 1 : shortList.count
        }
        }else{
            return self.showShimmer ? 1 : candidate.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! CompetitionsResultCell
        if !self.showShimmer {
            if result{
            if self.final {
                cell.confic (name : self.finalList[indexPath.row].name ?? "",profileUrl : self.finalList[indexPath.row].imageURL ?? "" , bannerUrl :self.finalList[indexPath.row].imageURL ?? "" ,isVote : self.finalList[indexPath.row].isVoted ?? false)
            }else{
                cell.confic (name : self.shortList[indexPath.row].name ?? "",profileUrl : self.shortList[indexPath.row].imageURL ?? "" , bannerUrl :self.shortList[indexPath.row].imageURL ?? "" ,isVote : self.shortList[indexPath.row].isVoted ?? false)
            }
            cell.voteBtn.isHidden = true

            }else{
                cell.confic (name : self.candidate[indexPath.row].name ?? "",profileUrl : self.candidate[indexPath.row].imageURL ?? "" , bannerUrl :self.candidate[indexPath.row].imageURL ?? "" ,isVote : self.candidate[indexPath.row].isVoted ?? false)
                cell.vote = {
                self.competitionVm.showIndicator()
                    self.voteCompetitions(competitionId: self.compId, candidateId:self.candidate[indexPath.row].id ?? 0)
                }
            }
        }
        cell.showShimmer = showShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showShimmer {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
}

extension CompetitionResultslistsVC{
    func voteCompetitions(competitionId :Int,candidateId :Int) {
        competitionVm.voteCompetitions(competitionId :competitionId,candidateId :candidateId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.competitionVm.dismissIndicator()
            self.tableView.reloadData()
            self.showMessage(text: dataModel.message ?? "")
           }else{
            self.competitionVm.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.competitionVm.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
