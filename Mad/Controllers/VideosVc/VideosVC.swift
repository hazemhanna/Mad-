//
//  ArtistVc.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class VideosVC: UIViewController {
   
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var  showsCollectionView: UICollectionView!
    @IBOutlet weak var interviewsCollectionView: UICollectionView!
    @IBOutlet weak var showCasesCollectionView: UICollectionView!
    @IBOutlet weak var afterMovieCollectionView: UICollectionView!
    
    var homeVM = HomeViewModel()
    var parentVC : HomeVC?

    var data = [String](){
          didSet {
              DispatchQueue.main.async {
                  self.homeVM.fetchMainData(data: self.data)
              }
          }
      }
    
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProductctiveCollectionView()
        setupshowsCollectionView()
        setupinterviewCollectionView()
        setupshowCacesCollectionView()
        setupAfterMovieCollectionView()
        self.data = ["8","7","6","5","4","3","2","1"]
    }
     
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

//MARK:- Data Binding
extension VideosVC: UICollectionViewDelegate {
    func setupProductctiveCollectionView() {
        let cellIdentifier = "ProjectCell"
        self.productCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.productCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ProjectCell.self)) { index, element, cell in
            
                cell.projectNameLabel.text = "Music"
                cell.catImage.isHidden = false
                cell.addProjectBtn.isHidden = true
               cell.projectNameLabel.textColor = UIColor.white
            
        }.disposed(by: disposeBag)
        self.productCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupshowsCollectionView() {
        let cellIdentifier = "ShowesCell"
        self.showsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.showsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.showsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ShowesCell.self)) { index, element, cell in
     
        }.disposed(by: disposeBag)
        self.showsCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupinterviewCollectionView() {
        let cellIdentifier = "ShowesCell"
        self.interviewsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.interviewsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.interviewsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ShowesCell.self)) { index, element, cell in
     
        }.disposed(by: disposeBag)
        self.interviewsCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupshowCacesCollectionView() {
        let cellIdentifier = "ShowesCell"
        self.showCasesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.showCasesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.showCasesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ShowesCell.self)) { index, element, cell in
     
        }.disposed(by: disposeBag)
        self.showCasesCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupAfterMovieCollectionView() {
        let cellIdentifier = "ShowesCell"
        self.afterMovieCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.afterMovieCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.afterMovieCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ShowesCell.self)) { index, element, cell in
     
        }.disposed(by: disposeBag)
        self.afterMovieCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
}

extension VideosVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else  {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height)
        }
    }
}

