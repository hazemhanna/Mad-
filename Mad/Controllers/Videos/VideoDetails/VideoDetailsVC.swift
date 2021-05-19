//
//  VideoDetailsVC.swift
//  Mad
//
//  Created by MAC on 11/05/2021.
//


import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class VideoDetailsVc : UIViewController {
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var titleView : UIView!

    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var bannerImage : UIImageView!
    @IBOutlet weak var likeLbl : UILabel!
    @IBOutlet weak var shareLbl : UILabel!
    @IBOutlet weak var likeBtn : UIButton!
    @IBOutlet weak var timeLbl : UILabel!

    var videoId = Int()
    var videoVM = VideosViewModel()
    var disposeBag = DisposeBag()
    var selectedIndex = 0
    var titles = [String](){
          didSet {
              DispatchQueue.main.async {
                  self.videoVM.fetchtitle(data: self.titles)
              }
          }
      }
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    lazy var instantVC1: VideoArtistsVc = {
        var vc = VideoArtistsVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    lazy var instantVC2: VideoProjectsVC = {
        var vc =  VideoProjectsVC.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    lazy var instantVC3: VideoPurchaseVc = {
        var vc =  VideoPurchaseVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    lazy var instantVC4: VideoPartners = {
        var vc = VideoPartners.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptitleCollectionView()
        selectView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getVideoDetails(id : self.videoId)
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
extension VideoDetailsVc: UICollectionViewDelegate {
    func setuptitleCollectionView() {
        self.titles = ["Artists","Projects","Purchase","Partners"]
        let cellIdentifier = "TitleCell"
        self.titleCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.titleCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.videoVM.title.bind(to: self.titleCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: TitleCell.self)) { index, element, cell in
            
             cell.titleBtn.text = self.titles[index]
            if self.selectedIndex == index{
                cell.titleBtn.textColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            }else {
                cell.titleBtn.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             }
            
        }.disposed(by: disposeBag)
        self.titleCollectionView.rx.itemSelected.bind { (indexPath) in
            self.selectedIndex = indexPath.row
            self.selectView()
            self.titleCollectionView.reloadData()
            
        }.disposed(by: disposeBag)
    }
   }

extension VideoDetailsVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 4
            return CGSize(width: size, height: 40)
    }
 }

  extension VideoDetailsVc {
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


extension VideoDetailsVc {
    func getVideoDetails(id : Int) {
        videoVM.getVideoDetails(id: id).subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
            if let bannerUrl = URL(string: dataModel.data?.imageURL ?? "" ){
                   self.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
               }
                self.likeLbl.text = "\(dataModel.data?.favoriteCount ?? 0)"
                self.shareLbl.text = "\(dataModel.data?.shareCount ?? 0)"
                self.titleLbl.text =  dataModel.data?.title ?? ""
                if dataModel.data?.isFavorite ?? false {
                self.likeBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
                }else{
                self.likeBtn.setImage(#imageLiteral(resourceName: "Path 326"), for: .normal)
                }
            self.instantVC2.project = dataModel.data?.projects ?? []
            self.instantVC3.product = dataModel.data?.products ?? []
            self.instantVC1.artist = dataModel.data?.artists ?? []
            }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
}
