//
//  ArtistProfileVc.swift
//  Mad
//
//  Created by MAC on 20/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class ArtistProfileVc: UIViewController {
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var projectContinerVie: UIView!
    
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
        self.titles = ["Projects","Products","About","Competitions"]
        projectContinerVie.isHidden = false
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
}

extension ArtistProfileVc : UICollectionViewDelegate {
    
    func setuptitleCollectionView() {
        let cellIdentifier = "TitleCell"
        self.titleCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.titleCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeVM.title.bind(to: self.titleCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: TitleCell.self)) { index, element, cell in
            
             cell.titleBtn.text = self.titles[index]
            if self.selectedIndex == index{
                cell.titleBtn.textColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            }else{
                cell.titleBtn.textColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
               }
            
        }.disposed(by: disposeBag)
        self.titleCollectionView.rx.itemSelected.bind { (indexPath) in
           
            self.selectedIndex = indexPath.row
            self.titleCollectionView.reloadData()
            
            if self.selectedIndex == 0 {
                self.projectContinerVie.isHidden = false
            }else if self.selectedIndex == 1 {
                self.projectContinerVie.isHidden = true
            }else if self.selectedIndex == 2{
                self.projectContinerVie.isHidden = true
            }else if self.selectedIndex == 3{
                self.projectContinerVie.isHidden = true
            }
        }.disposed(by: disposeBag)
    }
}


extension ArtistProfileVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.7
            return CGSize(width: size, height: 40)
    }
}
