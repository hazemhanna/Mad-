//
//  File.swift
//  Mad
//
//  Created by MAC on 11/05/2021.
//



import UIKit
import Tabman
import Pageboy



class VideoContainerVc: TabmanViewController {

    let vc1 = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProjectsVc") as! ArtistProjectsVc
    
    let vc2 = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProductsVc") as! ArtistProductsVc

    let vc3 = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "AboutVc") as! AboutVc

    let vc4 = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "CompetitionsVc") as! CompetitionsVc



    private lazy var viewControllers: [UIViewController] = [
        vc1,
        vc2,
        vc3,
        vc4,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        let bar = TMBarView.ButtonBar()
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 32.0, bottom: 4.0, right: 0.0)
        bar.layout.interButtonSpacing = 24.0
        bar.indicator.weight = .light
        bar.indicator.cornerStyle = .eliptical
        bar.fadesContentEdges = true
        bar.backgroundColor =  #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        bar.spacing = 16.0
        bar.buttons.customize {
            $0.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            $0.font = UIFont(name: "Graphik-Medium", size: 16)!
            $0.selectedTintColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
        }
        
        bar.indicator.tintColor = .clear
        addBar(bar.systemBar(), dataSource: self, at: .top)
                let fontFamilyNames = UIFont.familyNames
                for familyName in fontFamilyNames {
                    print("Font Family Name = [\(familyName)]")
                    let names = UIFont.fontNames(forFamilyName: familyName)
                    print("Font Names = [\(names)]")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.navigationBar.isHidden = true
    }
}

extension VideoContainerVc  : PageboyViewControllerDataSource, TMBarDataSource{

func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
    return viewControllers.count
}

func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
    return viewControllers[index]
}

func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
    return  nil
}

func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        if index == 0 {
            return TMBarItem(title:  "Artists")
        }else if index == 1  {
            return TMBarItem(title:  "Projects")
        }else if index == 2  {
            return TMBarItem(title:  "Purchase")
        }else {
           return TMBarItem(title:  "Partners")
        }
    
}
}
