//
//  SplashVC.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SplashVC: UIViewController {
    
    @IBOutlet weak var splashCollectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var firstView : UIView!
    @IBOutlet weak var secondView : UIView!
    @IBOutlet weak var thirdView : UIView!
    @IBOutlet weak var lastView : UIView!
    
    private let splashVM = SplashViewModel()
    var disposeBag = DisposeBag()

    var data = [SplashModel]() {
        didSet {
            DispatchQueue.main.async {
                self.splashVM.fetchsplash(splash: self.data)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashCollectionView()
        data.append(SplashModel(images: #imageLiteral(resourceName: "Component 5 – 1"), title: "JOIN AS A MADER", title2: "Discover artists & their projects"))
        data.append(SplashModel(images: #imageLiteral(resourceName: "Component 4 – 1"), title: "SHOP & ACQUIRE", title2: "artist creations"))
        data.append(SplashModel(images: #imageLiteral(resourceName: "Layer 0"), title: "Or JOIN AS AN ARTIST", title2: "get visibility & sell your creations"))
        data.append(SplashModel(images: #imageLiteral(resourceName: "Component 63 – 1"), title: "REGISTER & APPLY", title2: "to events and competitions"))
        
        firstView.clipsToBounds = true
        firstView.layer.cornerRadius = 3
        firstView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        lastView.clipsToBounds = true
        lastView.layer.cornerRadius = 3
        lastView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        splashCollectionView.isPagingEnabled = true
    }
    
    @IBAction func nextButton(sender: UIButton) {
        DispatchQueue.main.async {
            let lastIndex = (self.data.count) - 1
            let visibleIndices = self.splashCollectionView.indexPathsForVisibleItems
            let nextIndex = visibleIndices[0].row + 1
            if nextIndex > lastIndex {
                let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
                if let appDelegate = UIApplication.shared.delegate {
                    appDelegate.window??.rootViewController = sb
                }
            } else {
                self.splashCollectionView.scrollToNextItem()
          }
        }
    }
}

extension SplashVC: UICollectionViewDelegate {
    func setupSplashCollectionView() {
        let cellIdentifier = "SplashCell"
        self.splashCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.splashCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.splashVM.data.bind(to: self.splashCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: SplashCell.self)) { index, element, cell in
            cell.imageIcon.image = self.data[index].images
            cell.titleLbl.text = self.data[index].title
            cell.seconTitleleLbl.text = self.data[index].title2
        }.disposed(by: disposeBag)
        self.splashCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.firstView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
            self.secondView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
            self.thirdView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
            self.lastView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
        }else  if indexPath.row == 1{
            self.firstView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
            self.secondView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
            self.thirdView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
            self.lastView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
        }else  if indexPath.row == 2{
            self.firstView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
            self.secondView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
            self.thirdView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
            self.lastView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
        }else{
            self.firstView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
            self.secondView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
            self.thirdView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9490196078, alpha: 1)
            self.lastView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
        }
    }
}

extension SplashVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.frame.size.width), height: (collectionView.frame.size.height))
        
    }
}
