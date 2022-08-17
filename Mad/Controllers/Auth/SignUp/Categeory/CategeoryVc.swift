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
    @IBOutlet weak var intrestedLbl: UILabel!
    @IBOutlet weak var pickLbl: UILabel!

    var selectedIndex = -1
    var selectTwice = false
    
    
    
    let cellIdentifier = "CategeoryCell"
    var disposeBag = DisposeBag()
    
    private let AuthViewModel = AuthenticationViewModel()
    
    var SelectedCategories = [Int]()
    var Categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.CategoryCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.CategoryCollectionView.delegate = self
        self.CategoryCollectionView.dataSource = self
        self.AuthViewModel.showIndicator()
        getCategory()
        nextBtn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.5764705882, blue: 0.6745098039, alpha: 1)
        self.nextBtn.isEnabled = false
        intrestedLbl.text = "interested".localized
        pickLbl.text = "Pick".localized
        nextBtn.setTitle( "Next".localized, for: .normal)
        
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
}

extension CategeoryVc: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CategeoryCell
        
        cell.confic(icon: self.Categories[indexPath.row].imageURL ?? "", name: self.Categories[indexPath.row].name ?? "")
       
        if self.Categories[indexPath.row].show {
            cell.iconImage.isHidden = false
        }else{
            cell.iconImage.isHidden = true
        }
        
        cell.selectAction = {
            if  self.Categories[indexPath.row].show {
                 cell.iconImage.isHidden = true
                 self.Categories[indexPath.row].show = false
                 self.SelectedCategories.removeAll{$0 == self.Categories[indexPath.row].id ?? 0}
                 }else{
                    cell.iconImage.isHidden = false
                    self.Categories[indexPath.row].show = true
                    self.SelectedCategories.append(self.Categories[indexPath.row].id ?? 0 )
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
         AuthViewModel.attemptToCompleteProfile(categories: self.SelectedCategories,type: Helper.getType() ?? false).subscribe(onNext: { (registerData) in
            if registerData.success ?? false {
                self.AuthViewModel.dismissIndicator()
                Helper.saveAlogin(token: registerData.data?.accessToken ?? ""
                                  ,email: registerData.data?.user?.userEmail ?? ""
                                  , fName: registerData.data?.user?.firstName ?? ""
                                  ,lName : registerData.data?.user?.lastName ?? ""
                                  , type:  registerData.data?.user?.madArtist ?? false
                                  , id: registerData.data?.user?.artistID ?? 0
                                  , isActive: registerData.data?.user?.activatedArtist ?? false
                                  , profile: registerData.data?.user?.profilPicture ?? ""
                                  ,completed : registerData.data?.user?.completed_profile ?? false)

                let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardTabBarController")
                if let appDelegate = UIApplication.shared.delegate {
                    appDelegate.window??.rootViewController = sb
                }
                displayMessage(title: "",message: "MADer account created", status: .success, forController: self)

            }else{
                self.AuthViewModel.dismissIndicator()
                displayMessage(title: "",message: registerData.message ?? "", status: .error, forController: self)
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()

        }).disposed(by: disposeBag)
    }
}
