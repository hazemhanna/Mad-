//
//  ProductVc.swift
//  Mad
//
//  Created by MAC on 07/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ProductVc: UIViewController {
   
    @IBOutlet weak var addproductCollectionView: UICollectionView!
    @IBOutlet weak var  topPrpductCollectionView: UICollectionView!
    @IBOutlet weak var forYouCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    var homeVM = HomeViewModel()
    var parentVC : HomeVC?

    var data = [String](){
          didSet {
              DispatchQueue.main.async {
                  self.homeVM.fetchMainData(data: self.data)
              }
          }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopProductCollectionView()
        setupForYouCollectionView()
        setupProductCollectionView()
        setupAddProductCollectionView()
        self.data = ["8","7","6","5","4","3","2","1"]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}


extension ProductVc: UICollectionViewDelegate {
    func setupAddProductCollectionView() {
        let cellIdentifier = "ProjectCell"
        self.addproductCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.addproductCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.addproductCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ProjectCell.self)) { index, element, cell in
            if index == 0 {
                    cell.catImage.isHidden = true
                    cell.addProjectBtn.isHidden = false
                    cell.projectNameLabel.text = "creat project"
                }else{
                    cell.catImage.isHidden = false
                    cell.addProjectBtn.isHidden = true

                }
        }.disposed(by: disposeBag)
        self.addproductCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupTopProductCollectionView() {
        let cellIdentifier = "ForYouCell"
        self.topPrpductCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.topPrpductCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.topPrpductCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ForYouCell.self)) { index, element, cell in
                        
        }.disposed(by: disposeBag)
        self.topPrpductCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupForYouCollectionView() {
        let cellIdentifier = "ForYouCell"
        self.forYouCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.forYouCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.forYouCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ForYouCell.self)) { index, element, cell in
     
        }.disposed(by: disposeBag)
        self.forYouCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    
    func setupProductCollectionView() {
        let cellIdentifier = "ArtistCell"
        self.productCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.data.bind(to: self.productCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ArtistCell.self)) { index, element, cell in
     
        }.disposed(by: disposeBag)
        self.productCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
}

extension ProductVc: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == addproductCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: collectionView.frame.size.height)
        
        }else if collectionView == topPrpductCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 2.5
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else if collectionView == forYouCollectionView {

            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 2.2
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
