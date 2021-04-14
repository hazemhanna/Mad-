//
//  ArtistVc.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ArtistVc: UIViewController {
   
    @IBOutlet weak var  topActiveCollectionView: UICollectionView!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBOutlet weak var artistsCollectionView: UICollectionView!

    var homeVM = HomeViewModel()
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
        setupTopActiveCollectionView()
        setupSuggesteCollectionView()
        setupArtistCollectionView()
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
extension ArtistVc: UICollectionViewDelegate {
    func setupTopActiveCollectionView() {
        let cellIdentifier = "ProjectCell"
        self.topActiveCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.topActiveCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.topActiveCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ProjectCell.self)) { index, element, cell in
            
                    cell.addProjectBtn.isHidden = true
                    cell.projectNameLabel.text = "Music"
            
        }.disposed(by: disposeBag)
        self.topActiveCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupSuggesteCollectionView() {
        let cellIdentifier = "SuggestedCell"
        self.suggestedCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.suggestedCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.suggestedCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: SuggestedCell.self)) { index, element, cell in
     
        }.disposed(by: disposeBag)
        self.suggestedCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    
    func setupArtistCollectionView() {
        let cellIdentifier = "ArtistCell"
        self.artistsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.artistsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.artistsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ArtistCell.self)) { index, element, cell in
     
        }.disposed(by: disposeBag)
        self.artistsCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
}

extension ArtistVc: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topActiveCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else if collectionView == suggestedCollectionView {

            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.5
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else{
            
            let width : CGFloat
            let height : CGFloat
            if indexPath.item == 0 || indexPath.item == 2 || indexPath.item == 8  {
                width = 200
                height = 160
              }else if indexPath.item == 3 || indexPath.item == 2 {
              width = 116
              height = 140
              }else{
                width = 116
                height = 121
              }
            return CGSize(width: width, height: height)
        }
    }
}
