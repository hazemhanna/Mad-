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
    
    var disposeBag = DisposeBag()
    private let AdsVM = AdsViewModel()
    
    var ads = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.AdsVM.fetchAds(data: self.ads)

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isPagingEnabled = true
        setupCollectionView()
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
            let lastIndex = (self.ads.count) - 1
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
        ads = ["1","2","3","4"]
        let cellIdentifier = "WelcomeCell"
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.AdsVM.data.bind(to: self.collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: WelcomeCell.self)) { index, element, cell in
                    
            
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


