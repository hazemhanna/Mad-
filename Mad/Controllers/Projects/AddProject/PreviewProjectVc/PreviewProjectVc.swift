//
//  PreviewProjectVc.swift
//  Mad
//
//  Created by MAC on 02/06/2021.
//

import UIKit
import RxSwift
import RxCocoa


class PreviewProjectVc : UIViewController {
    
    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var liveCollectionViewHieht: NSLayoutConstraint!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var LikeLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favouriteStack : UIStackView!


    var selectedCat = [Int]()
    var selectedArtist = [Int]()
    var locationTF = String()
    var short_description = String()
    var titleTF = String()
    var summeryTf = String()
    var startDateTf = String()
    var endDateTf = String()
    var contentHtml = String()
    var uploadedPhoto :UIImage?
    var packages = [[String:String]]()
    var selectedproduct = [Int]()
    var disposeBag = DisposeBag()
    var prjectVM = ProjectViewModel()
    
    let cellIdentifier = "LiveCellCVC"
    var isFavourite  = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dateLbl.text = startDateTf
        titleLbl.text = titleTF
        NameLbl.text = startDateTf
        projectImage.image = uploadedPhoto
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(sender: UIButton) {
        AddProject(categories: selectedCat, title: titleTF, short_description: short_description, summery: summeryTf, content: contentHtml, startDate: startDateTf, endDate: endDateTf, location: locationTF, submit: "submit", packages: packages, products: selectedproduct, artists: selectedArtist, photos: uploadedPhoto ?? #imageLiteral(resourceName: "Mask Group 12111"))
        
    }
}


extension PreviewProjectVc  :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LiveCellCVC
        cell.showShimmer = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    
        let size:CGFloat = (collectionView.frame.size.width - space) / 1.4
            return CGSize(width: size, height: (collectionView.frame.size.height))
        }
}

extension PreviewProjectVc{
    func AddProject(categories :[Int],
                    title :String,
                    short_description:String,
                    summery:String,
                    content: String,
                    startDate: String,
                    endDate: String,
                    location: String,
                    submit:String,
                    packages:[[String:String]],
                    products:[Int],
                    artists:[Int],
                    photos:UIImage){
        
        prjectVM.CreatProject(title: title, content: content, short_description: short_description, summary: summery, image: photos, categories: categories, products: products, artists: artists, startDate: startDate, endDate: endDate, location: location, submit: submit, packages: packages).subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
                self.prjectVM.dismissIndicator()
                self.showMessage(text: dataModel.message ?? "")
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            }else{
                self.showMessage(text: dataModel.message ?? "")
            }
        }, onError: { (error) in

            self.prjectVM.dismissIndicator()

        }).disposed(by: disposeBag)
    }
    
}
