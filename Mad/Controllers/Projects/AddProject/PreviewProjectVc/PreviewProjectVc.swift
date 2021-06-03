//
//  PreviewProjectVc.swift
//  Mad
//
//  Created by MAC on 02/06/2021.
//

import UIKit

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
    @IBOutlet weak var trustImage: UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favouriteStack : UIStackView!


    let cellIdentifier = "LiveCellCVC"
    var isFavourite  = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self
        liveView.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    

    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton(sender: UIButton) {
        let vc = PreviewProjectVc.instantiateFromNib()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func confic (name : String,date : String, title : String , like :Int , share : Int, profileUrl : String , projectUrl :String , trustUrl : String,isFavourite : Bool){
        
        NameLbl.text = name
         dateLbl.text = date
         titleLbl.text = title
         LikeLbl.text = "\(like)"
        shareLbl.text = "\(share)"
        
        if let profileImageUrl = URL(string: profileUrl){
        self.profileImage.kf.setImage(with: profileImageUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
        if  let projectUrl = URL(string: projectUrl){
        self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
        }
        if let trustUrl = URL(string: trustUrl){
        self.trustImage.kf.setImage(with: trustUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
        }
        self.isFavourite = isFavourite
        if isFavourite {
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 155"), for: .normal)
        }else{
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "Group 140"), for: .normal)

        }
    }
}

extension PreviewProjectVc :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
