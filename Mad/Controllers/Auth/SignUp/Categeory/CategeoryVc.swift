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
    @IBOutlet weak var artistBtn: UIButton!

    let cellIdentifier = "CategeoryCell"
    var disposeBag = DisposeBag()
    
    private let AuthViewModel = AuthenticationViewModel()
    
    var SelectedCategories = [Int]()
    var Categories = [Category]()
    var type = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CategoryCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.CategoryCollectionView.delegate = self
        self.CategoryCollectionView.dataSource = self
        self.AuthViewModel.showIndicator()
        getCategory()
        nextBtn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.5764705882, blue: 0.6745098039, alpha: 1)
        self.nextBtn.isEnabled = false
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
    
    @IBAction func nextButton(sender: UIButton) {
        completeProfile()
    }

    
    @IBAction func madArtistAction(sender: UIButton) {
        if self.type == true {
            self.artistBtn.setImage(nil, for: .normal)
            type = false
        } else {
            self.artistBtn.setImage(#imageLiteral(resourceName: "icon - check (1)"), for: .normal)
            type = true
        }
    }
    
}

extension CategeoryVc: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CategeoryCell
        
        cell.catLbl.text = self.Categories[indexPath.row].name ?? ""

        if let url = URL(string:  self.Categories[indexPath.row].imageURL ?? ""){
        cell.catImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
         cell.selectAction = {
            if cell.iconImage.isHidden {
            cell.iconImage.isHidden = false
                self.SelectedCategories.append(self.Categories[indexPath.row].id ?? 0 )
            }else{
                cell.iconImage.isHidden = true
                self.SelectedCategories.removeAll{$0 == self.Categories[indexPath.row].id ?? 0}
            }
    
            if self.SelectedCategories.count >= 3 {
                self.nextBtn.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
                self.nextBtn.isEnabled = true
            }else{
                self.nextBtn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.5764705882, blue: 0.6745098039, alpha: 1)
                self.nextBtn.isEnabled = false
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
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


extension CategeoryVc {
     func getCategory() {
        AuthViewModel.getCategories().subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
                self.AuthViewModel.dismissIndicator()
                self.Categories = dataModel.data ?? []
                self.CategoryCollectionView.reloadData()
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}

extension CategeoryVc {
     func completeProfile() {
        AuthViewModel.attemptToCompleteProfile(categories: self.SelectedCategories,type: type).subscribe(onNext: { (registerData) in
            if registerData.success ?? false {
                self.AuthViewModel.dismissIndicator()
                let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardTabBarController")
                if let appDelegate = UIApplication.shared.delegate {
                    appDelegate.window??.rootViewController = sb
                }
                self.showMessage(text: registerData.message ?? "")

            }else{
                self.AuthViewModel.dismissIndicator()
                self.showMessage(text: registerData.message ?? "")
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}
