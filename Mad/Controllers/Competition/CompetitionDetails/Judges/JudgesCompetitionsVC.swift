//
//  JudgesCompetitionsVC.swift
//  Mad
//
//  Created by MAC on 10/06/2021.
//




import UIKit
import RxSwift
import RxCocoa

class JudgesCompetitionsVC : UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
   
    
    var  parentVC: CompetitionsDetailsVc?

    let cellIdentifier = "CompetitionCell"
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artistId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension JudgesCompetitionsVC : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! CompetitionCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = CompetitionsDetailsVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
}

extension JudgesCompetitionsVC{
    
}
