//
//  AboutVc.swift
//  Mad
//
//  Created by MAC on 23/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class AboutVc: UIViewController {
    
    @IBOutlet weak var  headLineLbL: UILabel!
    @IBOutlet weak var  aboutLbl: UILabel!
    @IBOutlet weak var  socialcollection: UICollectionView!
    @IBOutlet weak var  socialLoc: UILabel!
    @IBOutlet weak var  musiccatLabl: UILabel!
    @IBOutlet weak var  artcatLabl: UILabel!
    @IBOutlet weak var  designcatLabl: UILabel!

    let cellIdentifier = "SocialMediaCell"
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()
    var artistId = Helper.getArtistId() ?? 0
    var social  = [Social]()
    var music  = String()
    var art  = String()
    var design  = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        getArtistProfile(artistId : artistId)
        socialLoc.text = "SocialMedia".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension AboutVc : UICollectionViewDelegate ,UICollectionViewDataSource{

    func setupContentTableView() {
        socialcollection.delegate = self
        socialcollection.dataSource = self
        self.socialcollection.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: self.cellIdentifier)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return social.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SocialMediaCell
        cell.confic(name : self.social[indexPath.row].name ?? "" ,icon : self.social[indexPath.row].icon ?? "")
        cell.details = {
            if let url = self.social[indexPath.row].url {
            Helper.UIApplicationURL.openUrl(url: url)
            }
        }
        return cell
    }
    
}

extension AboutVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
      let size:CGFloat = (collectionView.frame.size.width - space) / 9
          return CGSize(width: size, height: (collectionView.frame.size.height))
    }
}

extension AboutVc  {
    func getArtistProfile(artistId : Int) {
        artistVM.getArtistProfile(artistId: artistId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.headLineLbL.text = dataModel.data?.headline ?? ""
            self.aboutLbl.text = dataModel.data?.about ?? ""

            if  dataModel.data?.music ?? false {
                self.musiccatLabl.text = "  Music  "
            }
            if  dataModel.data?.art ?? false {
                self.artcatLabl.text = "  Art  "
            }
            if  dataModel.data?.design ?? false {
                self.designcatLabl.text = "  Design  "
            }
            self.social = dataModel.data?.socialLinks ?? []
            self.socialcollection.reloadData()
           }
       }, onError: { (error) in
        self.artistVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
