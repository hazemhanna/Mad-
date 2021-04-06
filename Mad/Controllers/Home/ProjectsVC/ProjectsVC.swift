//
//  ProjectsVC.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//





import UIKit
import RxSwift
import RxCocoa

class ProjectsVC: UIViewController {
   
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    var homeVM = HomeViewModel()
    var data = [String](){
          didSet {
              DispatchQueue.main.async {
                  self.homeVM.fetchMainData(data: self.data)
              }
          }
      }
    
    var disposeBag = DisposeBag()
    private let CellIdentifier = "HomeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        setupProjectCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension ProjectsVC: UITableViewDelegate {
    func setupContentTableView() {
        self.data = ["8","7","6","5","4","3","2","1"]
        self.mainTableView.register(UINib(nibName: self.CellIdentifier, bundle: nil), forCellReuseIdentifier: self.CellIdentifier)
        self.mainTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = UITableView.automaticDimension
        self.homeVM.data.bind(to: self.mainTableView.rx.items(cellIdentifier: self.CellIdentifier, cellType: HomeCell.self)) { index, element, cell in
            
        }.disposed(by: disposeBag)
        self.mainTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        self.mainTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
}

//MARK:- Data Binding
extension ProjectsVC: UICollectionViewDelegate {
    func setupProjectCollectionView() {
        let cellIdentifier = "ProjectCell"
        self.projectCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.projectCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.projectCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ProjectCell.self)) { index, element, cell in
            if index == 0 {
                cell.ProjectStackView.isHidden = true
                cell.addProjectView.isHidden = false
                cell.addProjectLabel.isHidden = false

            }else{
                cell.ProjectStackView.isHidden = false
                cell.addProjectView.isHidden = true
                cell.addProjectLabel.isHidden = true
            }
            
        }.disposed(by: disposeBag)
        self.projectCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
}

extension ProjectsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: collectionView.frame.size.height)
    }
}
