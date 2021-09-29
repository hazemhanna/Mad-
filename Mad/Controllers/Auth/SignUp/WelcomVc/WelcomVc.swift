//
//  WelcomVc.swift
//  Mad
//
//  Created by MAC on 05/04/2021.
//

import UIKit
import RxSwift
import RxCocoa


class WelcomVc: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var creatBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!

  
    var disposeBag = DisposeBag()
    private let AdsVM = AdsViewModel()
    
    var data  = [SplashModel]() {
        didSet {
            DispatchQueue.main.async {
                self.AdsVM.fetchAds(data: self.data)

            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isPagingEnabled = true
        setupCollectionView()
        
        titleLbl.text = "Hello.Mad.artist".localized
        nextBtn.setTitle( "Next".localized, for: .normal)
        creatBtn.setTitle( "Create.Artist.Profile".localized, for: .normal)
        
        data.append(SplashModel(images: #imageLiteral(resourceName: "Mask Group 27"), title: "Compete".localized, title2: "Apply.to".localized))
        data.append(SplashModel(images: #imageLiteral(resourceName: "Mask Group 34"), title: "Sell".localized, title2: "We.love".localized))
        data.append(SplashModel(images: #imageLiteral(resourceName: "pawel-szvmanski-i73F7ma3Q9k-unsplash"), title: "Artfluencer".localized, title2: "Create.content".localized))
        data.append(SplashModel(images: #imageLiteral(resourceName: "mohsen-shenavari-0WkVr4IINKQ-unsplash"), title: "Get.featured".localized, title2: "Shows.interviews".localized))
        data.append(SplashModel(images: #imageLiteral(resourceName: "Mask Group 32"), title: "What.are".localized, title2: "Create.your.projects".localized))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func creatArtistButton(sender: UIButton) {
        let main = EmailVc.instantiateFromNib()
        main?.register = true
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func nexButton(sender: UIButton) {
        DispatchQueue.main.async {
            let lastIndex = (self.data.count) - 1
            let visibleIndices = self.collectionView.indexPathsForVisibleItems
            let nextIndex = visibleIndices[0].row + 1
            let nextIndexPath: IndexPath = IndexPath.init(item: nextIndex, section: 0)
            if nextIndex > lastIndex {
                
            } else {
                self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
          }
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
}


extension WelcomVc: UICollectionViewDelegate {
    func setupCollectionView() {

        let cellIdentifier = "WelcomeCell"
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.AdsVM.data.bind(to: self.collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: WelcomeCell.self)) { index, element, cell in
            cell.imageIcon.image = self.data[index].images
            cell.titleLbl.text = self.data[index].title
            cell.seconTitleleLbl.text = self.data[index].title2
            
        }.disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected.bind { (indexPath) in

        }.disposed(by: disposeBag)

    }
    
}

extension WelcomVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space)
        return CGSize(width: size, height: collectionView.frame.size.height)
        
    }
}


