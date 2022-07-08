//
//  HomeVc.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class HomeVC: UIViewController {
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var titleView : UIView!
    @IBOutlet weak var blackView : UIView!
    @IBOutlet weak var nameLbl : UILabel!

    var token = Helper.getAPIToken() ?? ""
    var homeVM = HomeViewModel()
    var disposeBag = DisposeBag()
    var selectedIndex = 0
    var isCompleted = Helper.getUpgrade() ?? false
    var madArtist = Helper.getType() ?? false
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
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
        selectView()
        if self.token == "" {
            blackView.isHidden = true
        }else{
         if madArtist{
             if isCompleted || Helper.getIsActive() ?? false{
                blackView.isHidden = true
            }else{
                  homeVM.showIndicator()
                  getProfile()
                  blackView.isHidden = false
            }
            }else{
                blackView.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
     self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    lazy var instantVC1: ArtistsVc = {
        var vc = ArtistsVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
    lazy var instantVC2: ProductsVC = {
        var vc =  ProductsVC.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
    lazy var instantVC3: HomeCompetitionsVc = {
        var vc =  HomeCompetitionsVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
    lazy var instantVC4: ProjectsVC = {
        var vc =  ProjectsVC.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()

    lazy var instantVC5: BlogsVc = {
        var vc = BlogsVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
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
    @IBAction func completeAction(_ sender: UIButton) {
        self.blackView.isHidden = true
        let main = EditMyProfileVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    @IBAction func dismisAction(_ sender: UIButton) {
        self.blackView.isHidden = true
    }
}

//MARK:- Data Binding
extension HomeVC: UICollectionViewDelegate {
    func setuptitleCollectionView() {
        self.titles = ["artist".localized,"Shop.Home".localized,"Competitions".localized,"Projects".localized,"Blog".localized]
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
            }else {
                cell.backView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1).cgColor
                cell.backView.layer.borderWidth = 0
                cell.backView.layer.cornerRadius = 0
                cell.titleBtn.textColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
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
            
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.5
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
        
        func getProfile() {
            homeVM.getMyProfile().subscribe(onNext: { (dataModel) in
               if dataModel.success ?? false {
                self.homeVM.dismissIndicator()
                self.nameLbl.text = "HI".localized + " " + (dataModel.data?.name ?? "")
               }
           }, onError: { (error) in
            self.homeVM.dismissIndicator()

           }).disposed(by: disposeBag)
        }
    }
