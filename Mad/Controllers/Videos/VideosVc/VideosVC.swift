//
//  ArtistVc.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class VideosVC: UIViewController {
   
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var  showsCollectionView: UICollectionView!
    @IBOutlet weak var interviewsCollectionView: UICollectionView!
    @IBOutlet weak var showCasesCollectionView: UICollectionView!
    @IBOutlet weak var afterMovieCollectionView: UICollectionView!
    
    var homeVM = HomeViewModel()
    var parentVC : HomeVC?
    let cellIdentifier = "ProjectCell"
    let cellIdentifier2 = "ShowesCell"
    
    var showShimmer1: Bool = true
    var showShimmer2: Bool = true
    var showShimmer3: Bool = true
    var showShimmer4: Bool = true
    var showShimmer5: Bool = true
    
    var data = [String](){
          didSet {
              DispatchQueue.main.async {
                  self.homeVM.fetchMainData(data: self.data)
              }
          }
      }
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
    }
    
    func registerNib(){
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.showsCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        showsCollectionView.delegate = self
        showsCollectionView.dataSource = self
        self.interviewsCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        interviewsCollectionView.delegate = self
        interviewsCollectionView.dataSource = self
        self.showCasesCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        showCasesCollectionView.delegate = self
        showCasesCollectionView.dataSource = self
        self.afterMovieCollectionView.register(UINib(nibName: cellIdentifier2, bundle: nil), forCellWithReuseIdentifier: cellIdentifier2)
        afterMovieCollectionView.delegate = self
        afterMovieCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

//MARK:- Data Binding
extension VideosVC: UICollectionViewDelegate , UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView {
            return  self.showShimmer1 ? 5 : 5
            }else if collectionView == showsCollectionView{
                return  self.showShimmer2 ? 5 : 4
            }else if collectionView == interviewsCollectionView{
                return  self.showShimmer3 ? 5 : 3
            }else if collectionView == showCasesCollectionView{
                return  self.showShimmer4 ? 5 : 3
            }else{
                return  self.showShimmer5 ? 5 : 3
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProjectCell
                cell.projectNameLabel.text = "Music"
                cell.catImage.isHidden = false
                cell.addProjectBtn.isHidden = true
                cell.projectNameLabel.textColor = UIColor.white
                cell.showShimmer = showShimmer1
        return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! ShowesCell
            cell.showShimmer = showShimmer2
            return cell
        }
    }
}

extension VideosVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 5
            return CGSize(width: size, height: collectionView.frame.size.height)
        }else  {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height)
        }
    }
}

