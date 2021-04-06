//
//  HomeVc.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var projectContinerVie: UIView!
    @IBOutlet weak var artistContinerVie: UIView!
    @IBOutlet weak var productsContinerVie: UIView!
    @IBOutlet weak var videosContinerVie: UIView!
    @IBOutlet weak var blogsContinerVie: UIView!


    
    var homeVM = HomeViewModel()
    var disposeBag = DisposeBag()
    var selectedIndex = 0

    var titles = [String](){
          didSet {
              DispatchQueue.main.async {
                  self.homeVM.fetchtitle(data: self.titles)
              }
          }
      }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptitleCollectionView()
        
        projectContinerVie.isHidden = false
        artistContinerVie.isHidden = true
        productsContinerVie.isHidden = true
        videosContinerVie.isHidden = true
        blogsContinerVie.isHidden = true
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
}

//MARK:- Data Binding
extension HomeVC: UICollectionViewDelegate {
    func setuptitleCollectionView() {
        self.titles = ["Projects","Artists","Products","Videos","Blogs"]
        let cellIdentifier = "TitleCell"
        self.titleCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.titleCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.title.bind(to: self.titleCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: TitleCell.self)) { index, element, cell in
            
             cell.titleBtn.text = self.titles[index]
            if self.selectedIndex == index{
                cell.backView.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1).cgColor
                cell.backView.layer.borderWidth = 2
                cell.backView.layer.cornerRadius = 20
                cell.titleBtn.textColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            }else{
                cell.backView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1).cgColor
                cell.backView.layer.borderWidth = 0
                cell.backView.layer.cornerRadius = 0
                cell.titleBtn.textColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
               }
            
            
        }.disposed(by: disposeBag)
        self.titleCollectionView.rx.itemSelected.bind { (indexPath) in
            self.selectedIndex = indexPath.row
           self.titleCollectionView.reloadData()
            if self.selectedIndex == 0 {
                self.projectContinerVie.isHidden = false
                self.artistContinerVie.isHidden = true
                self.productsContinerVie.isHidden = true
                self.videosContinerVie.isHidden = true
                self.blogsContinerVie.isHidden = true
            }else if self.selectedIndex == 1 {
                self.projectContinerVie.isHidden = true
                self.artistContinerVie.isHidden = false
                self.productsContinerVie.isHidden = true
                self.videosContinerVie.isHidden = true
                self.blogsContinerVie.isHidden = true
            }else if self.selectedIndex == 2{
                self.projectContinerVie.isHidden = true
                self.artistContinerVie.isHidden = true
                self.productsContinerVie.isHidden = false
                self.videosContinerVie.isHidden = true
                self.blogsContinerVie.isHidden = true
            }else if self.selectedIndex == 3{
                self.projectContinerVie.isHidden = true
                self.artistContinerVie.isHidden = true
                self.productsContinerVie.isHidden = true
                self.videosContinerVie.isHidden = false
                self.blogsContinerVie.isHidden = true
            }else if self.selectedIndex == 4{
                self.projectContinerVie.isHidden = true
                self.artistContinerVie.isHidden = true
                self.productsContinerVie.isHidden = true
                self.videosContinerVie.isHidden = true
                self.blogsContinerVie.isHidden = false
            }
        }.disposed(by: disposeBag)
    }
    
    

}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 4
            return CGSize(width: size, height: 40)
    }
}
