//
//  BlogDetailsVc.swift
//  Mad
//
//  Created by MAC on 24/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class BlogDetailsVc : UIViewController {

    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var screenTitleLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var contentSizeHieght : NSLayoutConstraint!
    @IBOutlet weak var container: UIView!

    var titles = [String](){
          didSet {
              DispatchQueue.main.async {
                  self.blogsVM.fetchtitle(data: self.titles)
              }
          }
      }
    
    var blogsVM = BlogsViewModel()
    var disposeBag = DisposeBag()
    var showShimmer: Bool = true
    var blogId = 0
    var isFavourite: Bool = false
    var token = Helper.getAPIToken() ?? ""
    var selectedIndex = 0

    let cellIdentifier = "LiveCellCVC"
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    
    lazy var instantVC1: AboutBlogVc = {
        var vc = AboutBlogVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    
    lazy var instantVC2: ArtistBlogVc = {
        var vc =  ArtistBlogVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    lazy var instantVC3: ProductBlogVc = {
        var vc =  ProductBlogVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()
    lazy var instantVC4: ProjectBlogVc = {
        var vc = ProjectBlogVc.instantiateFromNib()
        self.add(asChildViewController: vc!)
        vc!.parentVC = self
        return vc!
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blogsVM.showIndicator()
        screenTitleLbl.text = "blogDetails".localized
        selectView()
        setuptitleCollectionView()
    }
    
    func selectView(){
        self.remove(asChildViewController: self.instantVC1)
        self.remove(asChildViewController: self.instantVC2)
        self.remove(asChildViewController: self.instantVC3)
        self.remove(asChildViewController: self.instantVC4)

        switch  self.selectedIndex {
        case 0: self.add(asChildViewController: self.instantVC1)
        case 1: self.add(asChildViewController: self.instantVC2)
        case 2: self.add(asChildViewController: self.instantVC3)
        case 3: self.add(asChildViewController: self.instantVC4)
            
        default:  break
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getBlogsDetails(blogId : self.blogId)
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   @IBAction func shareAction(_ sender: UIButton) {
         if self.token == "" {
            displayMessage(title: "",message: "please login first".localized, status: .success, forController: self)
            let sb = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoadingLoginVc")
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = sb
            }
            return
        }
        self.blogsVM.showIndicator()
        self.shareBlog(blogId : self.blogId)
        let text =  "https://mader.page.link/"
        let textToShare = [text] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)

    }
    
}

//MARK:- Data Binding
extension BlogDetailsVc: UICollectionViewDelegate {
    func setuptitleCollectionView() {
        self.titles = ["Blogs","Artists","Products","Projects"]
        let cellIdentifier = "TitleCell"
        self.titleCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.titleCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.blogsVM.title.bind(to: self.titleCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: TitleCell.self)) { index, element, cell in
            
             cell.titleBtn.text = self.titles[index]
            if self.selectedIndex == index{
                cell.titleBtn.textColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
            }else {
                cell.titleBtn.textColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
             }
            
        }.disposed(by: disposeBag)
        self.titleCollectionView.rx.itemSelected.bind { (indexPath) in
            self.selectedIndex = indexPath.row
            self.selectView()
            self.titleCollectionView.reloadData()
            
        }.disposed(by: disposeBag)
    }
   }

extension BlogDetailsVc : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 4
            return CGSize(width: size, height: 40)
    }
 }

  extension BlogDetailsVc {
            private func add(asChildViewController viewController: UIViewController) {
                addChild(viewController)
                container.addSubview(viewController.view)
                viewController.view.frame = container.bounds
                viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                viewController.didMove(toParent: self)
            }

            private func remove(asChildViewController viewController: UIViewController) {
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
    }

extension BlogDetailsVc {
    
func getBlogsDetails(blogId : Int) {
    blogsVM.getBlogsDetails(blogId: blogId).subscribe(onNext: { (data) in
       if data.success ?? false {
        self.blogsVM.dismissIndicator()
        self.shareLbl.text = "\(data.data?.shareCount ?? 0)"
        self.titleLbl.text = data.data?.title ?? ""
        var projectCat = [String]()
        for cat in data.data?.categories ?? []{
            projectCat.append(cat.name ?? "")
        }
          self.typeLbl.text =   projectCat.joined(separator: ",")
           if let projectUrl = URL(string: data.data?.imageURL ?? ""){
           self.projectImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "WhatsApp Image 2021-04-21 at 1.25.47 PM"))
           }
           
           let  myVariable = "<font face='Graphik-Regular' size='16' color= 'black'>%@"
           let varr = String(format: myVariable, (data.data?.content ?? ""))
           self.instantVC1.webView.loadHTMLString(varr, baseURL: nil)
           self.instantVC2.artist = data.data?.relate_artists ?? []
           self.instantVC3.product = data.data?.relateProducts ?? []
           self.instantVC4.project = data.data?.relate_projects ?? []
           
       }
   }, onError: { (error) in
    self.blogsVM.dismissIndicator()
   }).disposed(by: disposeBag)
  }
    
    func shareBlog(blogId : Int) {
        blogsVM.shareBlogs(blogsId: blogId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.blogsVM.dismissIndicator()
            self.getBlogsDetails(blogId : blogId)
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)
            let text = self.titleLbl.text ?? ""
            let image = self.projectImage.image
            let textToShare = [text ,image] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
          activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
            
           }
       }, onError: { (error) in
        self.blogsVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    func addToFavourite(artistId : Int,Type : Bool) {
        blogsVM.addToFavourite(artistId: artistId, Type: Type).subscribe(onNext: { [self] (dataModel) in
           if dataModel.success ?? false {
            self.blogsVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.blogsVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
    
    func addProjectToFavourite(projectID : Int,Type : Bool) {
        blogsVM.addProjectToFavourite(projectID: projectID, Type: Type).subscribe(onNext: { [self] (dataModel) in
           if dataModel.success ?? false {
            self.blogsVM.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.blogsVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
    
}

