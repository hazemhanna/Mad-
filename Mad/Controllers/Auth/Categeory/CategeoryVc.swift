//
//  CategeoryVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit
import RxSwift
import RxCocoa


class CategeoryVc: UIViewController {

    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!

    var disposeBag = DisposeBag()
    private let CategeoryVM = CategeoryViewModel()
    var SelectedCategories = [String]() 

    var Categories = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.CategeoryVM.fetchCategories(Categories: self.Categories)

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryCollectionView()
        
        nextBtn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.5764705882, blue: 0.6745098039, alpha: 1)
    
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

extension CategeoryVc: UICollectionViewDelegate {
    func setupCategoryCollectionView() {
        Categories = ["1","2","3","4","4","4","4","1","2","3","4","4","4","4","1","2","3","4","4","4","4"]
        let cellIdentifier = "CategeoryCell"
        self.CategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CategoryCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.CategeoryVM.Categories.bind(to: self.CategoryCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: CategeoryCell.self)) { index, element, cell in
        
            cell.selectAction = {
                if cell.iconImage.isHidden {
                cell.iconImage.isHidden = false
                    self.SelectedCategories.append("1")
                }else{
                    cell.iconImage.isHidden = true
                    self.SelectedCategories.remove(at: index)
                }
                
                if self.SelectedCategories.count >= 3 {
                    self.nextBtn.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
                    self.nextBtn.isEnabled = true
                }else{
                    self.nextBtn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.5764705882, blue: 0.6745098039, alpha: 1)
                    self.nextBtn.isEnabled = false
                }
            }
            
            
        }.disposed(by: disposeBag)
        
        self.CategoryCollectionView.rx.itemSelected.bind { (indexPath) in

        }.disposed(by: disposeBag)

    }
    
}

extension CategeoryVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.1
        return CGSize(width: size, height: size + 10)
        
    }
}
