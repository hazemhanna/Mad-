//
//  MyprofileProducts.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//


import UIKit
import RxSwift
import RxCocoa

class MyprofileProducts : UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var draftLbl: UILabel!
    @IBOutlet weak var ordertLbl: UILabel!

    @IBOutlet weak var availabeLbl : UILabel!

    
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    let cellIdentifier = "LiveCellCVC"
    var products = [Product]()
    var publishProducts = [Product]()
    var pendingProducts = [Product]()
    var draftProducts = [Product]()
    
    var pendding = false
    
     var showShimmer = true
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.productCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfile()
        self.navigationController?.navigationBar.isHidden = true
        pendingBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
        publishBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
    }
    
    
    @IBAction func addProductButton(sender: UIButton) {
        let vc = AddProductImageVc.instantiateFromNib()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func pendingBtn(sender: UIButton) {
        if sender.tag == 0 {
            pendingBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            publishBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            self.products = publishProducts
            self.productCollectionView.reloadData()
            self.pendding = false

            if products.count > 0 {
                self.availabeLbl.isHidden = true
            }else{
                self.availabeLbl.isHidden = false
            }
            
        }else{
            publishBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            pendingBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            self.products = pendingProducts
            self.productCollectionView.reloadData()
            self.pendding = true
            
            if products.count > 0 {
                self.availabeLbl.isHidden = true
            }else{
                self.availabeLbl.isHidden = false
            }
            
        }
    }
    
    @IBAction func draftBtn(sender: UIButton) {
    let main = DraftsVc.instantiateFromNib()
    main?.products = draftProducts
    main?.draftType = "product"
    self.navigationController?.pushViewController(main!, animated: true)
    }
    
}


extension MyprofileProducts :  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 3 : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LiveCellCVC
        if !self.showShimmer {
            cell.priceLbl.text = "USD \(self.products[indexPath.row].price ?? 0.0)"
            cell.titleLabel.text = self.products[indexPath.row].title ?? ""

            if let bannerUrl = URL(string:   self.products[indexPath.row].imageURL ?? ""){
            cell.bannerImage.kf.setImage(with: bannerUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
            cell.editBtn.isHidden = false
        }
         cell.showShimmer = showShimmer
        cell.editBtn.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if pendding {
            displayMessage(title: "", message: "This Product Not Published", status: .error, forController: self)
        }else{
            let vc = ProductDetailsVC.instantiateFromNib()
            vc?.isFromProfile = true
            vc?.productId = self.products[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
extension MyprofileProducts : UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    
        let size:CGFloat = (collectionView.frame.size.width - space) - 32
            return CGSize(width: size, height: 140)
        }
    
}



extension MyprofileProducts  {
    func getProfile() {
        artistVM.getMyProfile().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer  = false
            self.products = dataModel.data?.products ?? []
            self.publishProducts = dataModel.data?.products ?? []
            self.pendingProducts = dataModel.data?.pendingProducts ?? []
            self.draftProducts = dataModel.data?.draftProducts ?? []
        
            self.pendingBtn.setTitle("Pending [\(self.pendingProducts.count)]", for: .normal)
            self.draftLbl.text = "All Drafts [\(dataModel.data?.draftProducts?.count ?? 0)]"

            self.productCollectionView.reloadData()
            
            if dataModel.data?.products?.count ?? 0  > 0 {
                self.availabeLbl.isHidden = true
            }else{
                self.availabeLbl.isHidden = false
            }
            
         }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}

