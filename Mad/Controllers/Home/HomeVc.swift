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
    @IBOutlet weak var container: UIView!
    
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

    lazy var instantVC1: ProjectsVC = {
        var vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ProjectsVC")  as! ProjectsVC
        self.add(asChildViewController: vc)
        vc.parentVC = self
        return vc
    }()
    lazy var instantVC2: ArtistVc = {
        var vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ArtistVc")  as! ArtistVc
        self.add(asChildViewController: vc)
        vc.parentVC = self
        return vc
    }()
    lazy var instantVC3: ProductVc = {
        var vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ProductVc")   as! ProductVc
        self.add(asChildViewController: vc)
        vc.parentVC = self
        return vc
    }()
    lazy var instantVC4: VideosVc = {
        var vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "VideosVc")  as! VideosVc
        self.add(asChildViewController: vc)
        vc.parentVC = self
        return vc
    }()
    lazy var instantVC5: BlogsVc = {
        var vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "BlogsVc") as! BlogsVc
        self.add(asChildViewController: vc)
        vc.parentVC = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptitleCollectionView()
        selectView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    func selectView(){
        self.remove(asChildViewController: self.instantVC1)
        self.remove(asChildViewController: self.instantVC2)
        self.remove(asChildViewController: self.instantVC3)
        self.remove(asChildViewController: self.instantVC4)
        self.remove(asChildViewController: self.instantVC5)

        switch  self.selectedIndex {
        case 0: self.add(asChildViewController: self.instantVC1)
        case 1: self.add(asChildViewController: self.instantVC2)
        case 2: self.add(asChildViewController: self.instantVC3)
        case 3: self.add(asChildViewController: self.instantVC4)
        case 4: self.add(asChildViewController: self.instantVC5)
    
        default:  break
        }
        
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
            if self.selectedIndex == 3 {
                self.view.backgroundColor = UIColor.black
                if self.selectedIndex == index{
                    cell.backView.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1).cgColor
                    cell.backView.layer.borderWidth = 2
                    cell.backView.layer.cornerRadius = 20
                    cell.titleBtn.textColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
                }else {
                    cell.backView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1).cgColor
                    cell.backView.layer.borderWidth = 0
                    cell.backView.layer.cornerRadius = 0
                    cell.titleBtn.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                   }
                
            }else{
                self.view.backgroundColor = UIColor.white
            if self.selectedIndex == index{
                cell.backView.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1).cgColor
                cell.backView.layer.borderWidth = 2
                cell.backView.layer.cornerRadius = 20
                cell.titleBtn.textColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            }else {
                cell.backView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1).cgColor
                cell.backView.layer.borderWidth = 0
                cell.backView.layer.cornerRadius = 0
                cell.titleBtn.textColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
               }
            }
            
        }.disposed(by: disposeBag)
        self.titleCollectionView.rx.itemSelected.bind { (indexPath) in
            self.selectedIndex = indexPath.row
            self.selectView()
            self.titleCollectionView.reloadData()
            
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

extension HomeVC {
            private func add(asChildViewController viewController: UIViewController) {
                // Add Child View Controller
                addChild(viewController)
                
                // Add Child View as Subview
                container.addSubview(viewController.view)
                // Configure Child View
                viewController.view.frame = container.bounds
                viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                // Notify Child View Controller
                viewController.didMove(toParent: self)
            }

            private func remove(asChildViewController viewController: UIViewController) {
                // Notify Child View Controller
                viewController.willMove(toParent: nil)
                // Remove Child View From Superview
                viewController.view.removeFromSuperview()
                // Notify Child View Controller
                viewController.removeFromParent()
            }
    }
