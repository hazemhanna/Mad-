//
//  CompetitionsDetailsVc.swift
//  Mad
//
//  Created by MAC on 09/06/2021.
//


import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar
import AVKit
import AVFoundation

class CompetitionsDetailsVc  : UIViewController {
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var bannerImage : UIImageView!
    
    var compId = Int()
    var competitionVm = CometitionsViewModel()
    var disposeBag = DisposeBag()
    var selectedIndex = 0

    var titles = [String](){
          didSet {
              DispatchQueue.main.async {
                  self.competitionVm.fetchtitle(data: self.titles)
              }
          }
      }
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    lazy var instantVC1: AboutCompetitionsVc = {
        var vc = AboutCompetitionsVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    lazy var instantVC2: GuidlinesCompetitionsVC = {
        var vc =  GuidlinesCompetitionsVC.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    lazy var instantVC3: DeadlinesCompetitionsVc = {
        var vc =  DeadlinesCompetitionsVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
    lazy var instantVC4: PrizesCometitionsVc = {
        var vc =  PrizesCometitionsVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
    lazy var instantVC5: JudgesCompetitionsVC = {
        var vc =  JudgesCompetitionsVC.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
    lazy var instantVC6: PartenersVc = {
        var vc = PartenersVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        vc!.view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        return vc!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptitleCollectionView()
        selectView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        competitionVm.showIndicator()
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getCompetitions(compId :self.compId)
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectView(){
        self.remove(asChildViewController: self.instantVC1)
        self.remove(asChildViewController: self.instantVC2)
        self.remove(asChildViewController: self.instantVC3)
        self.remove(asChildViewController: self.instantVC4)
        self.remove(asChildViewController: self.instantVC5)
        self.remove(asChildViewController: self.instantVC6)

        switch  self.selectedIndex {
        case 0: self.add(asChildViewController: self.instantVC1)
        case 1: self.add(asChildViewController: self.instantVC2)
        case 2: self.add(asChildViewController: self.instantVC3)
        case 3: self.add(asChildViewController: self.instantVC4)
        case 4: self.add(asChildViewController: self.instantVC5)
        case 5: self.add(asChildViewController: self.instantVC6)

        default:  break
        }
        
    }
    
}


//MARK:- Data Binding
extension CompetitionsDetailsVc: UICollectionViewDelegate {
    func setuptitleCollectionView() {
        self.titles = ["About","Guidlines","Deadlines","Prizes","Judges","Partners"]
        let cellIdentifier = "TitleCell"
        self.titleCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.titleCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.competitionVm.title.bind(to: self.titleCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: TitleCell.self)) { index, element, cell in
            
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

extension CompetitionsDetailsVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 4
            return CGSize(width: size, height: 40)
    }
 }

  extension CompetitionsDetailsVc {
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


extension CompetitionsDetailsVc {
    
    func getCompetitions(compId :Int) {
        competitionVm.getCompetitionsDetails(id: compId).subscribe(onNext: { (dataModel) in
            self.competitionVm.dismissIndicator()
           if dataModel.success ?? false {
            self.instantVC1.aboutTV.text = dataModel.data?.about?.html2String ?? ""
            self.instantVC2.guideTV.text = dataModel.data?.guidelines?.html2String ?? ""
            self.instantVC3.deadlinesTV.text = dataModel.data?.deadlines?.html2String ?? ""
            self.instantVC4.prizersTV.text = dataModel.data?.prizes?.html2String ?? ""
            self.instantVC5.judges =  dataModel.data?.judges ?? []
            self.instantVC6.partenersTV.text  = dataModel.data?.partner?.html2String ?? ""
            if let url = URL(string: dataModel.data?.bannerImg ?? ""){
                self.bannerImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
            }
         }
       }, onError: { (error) in
        self.competitionVm.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
}
