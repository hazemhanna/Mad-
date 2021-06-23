//
//  SearchResultVc.swift
//  Mad
//
//  Created by MAC on 23/06/2021.
//



import UIKit
import RxSwift
import RxCocoa

class SearchResultVc  : UIViewController {
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var container: UIView!

    var searchVM = SearchViewModel()
    var disposeBag = DisposeBag()
    var selectedIndex = 0
   

    var titles = [String](){
          didSet {
              DispatchQueue.main.async {
                  self.searchVM.fetchtitle(data: self.titles)
              }
          }
      }

    lazy var instantVC1: SearchArtistVC = {
        var vc = SearchArtistVC.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    lazy var instantVC2: SearchItemsVC = {
        var vc =  SearchItemsVC.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    lazy var instantVC3: SearchTagsVC = {
        var vc =  SearchTagsVC.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
    lazy var instantVC4: SearchCompetitionsVC = {
        var vc =  SearchCompetitionsVC.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptitleCollectionView()
        instantVC1.artists = [1,2,3,4,5]
        instantVC2.items = [1,2,3,4,5]
        instantVC3.tags = [1,2,3,4,5]
        instantVC4.competitions = [1,2,3,4,5]
        selectView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectView(){
        self.remove(asChildViewController: self.instantVC1)
        self.remove(asChildViewController: self.instantVC2)
        self.remove(asChildViewController: self.instantVC3)
        self.remove(asChildViewController: self.instantVC4)

        switch  self.selectedIndex {
        case 0: self.add(asChildViewController: self.instantVC1)
        case 1: self.add(asChildViewController: self.instantVC2)
        case 2: self.add(asChildViewController: self.instantVC3)
        case 3: self.add(asChildViewController: self.instantVC4)
        default:  break
        }
    }
    
    
}

//MARK:- Data Binding
extension SearchResultVc: UICollectionViewDelegate {
    func setuptitleCollectionView() {
        self.titles = ["Artists","Items","Tags","Competitions"]
        let cellIdentifier = "TitleCell"
        self.titleCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.titleCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.searchVM.title.bind(to: self.titleCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: TitleCell.self)) { index, element, cell in
            
             cell.titleBtn.text = self.titles[index]
            if self.selectedIndex == index{
                cell.titleBtn.textColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            }else {
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

extension SearchResultVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.5
            return CGSize(width: size, height: 40)
    }
 }

  extension SearchResultVc {
            private func add(asChildViewController viewController: UIViewController) {
                addChild(viewController)
                container.addSubview(viewController.view)
                viewController.view.frame = container.bounds
                viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                viewController.didMove(toParent: self)
            }

            private func remove(asChildViewController viewController: UIViewController) {
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
    }


extension SearchResultVc {
    
}
