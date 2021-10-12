//
//  MyProfileContainerVC.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//

import UIKit
import Tabman
import Pageboy


class MyProfileContainerVC : TabmanViewController {

    var active = Helper.getIsActive() ?? false
    
    let vc1 = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "MyProfileProjects") as! MyProfileProjects
    let vc2 = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "MyprofileProducts") as! MyprofileProducts
    let vc3 = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "MyProfileAbout") as! MyProfileAbout
    let vc4 = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "MyProfileCompetitions") as! MyProfileCompetitions
    let vc5 = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "MyProfileVideos") as! MyProfileVideos

    private lazy var viewControllers : [UIViewController] = [vc3,
                                                             vc2,
                                                             vc1,
                                                              vc4,
                                                              vc5]
    
    private lazy var viewControllers2 : [UIViewController] = [vc3,
                                                             vc4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        let bar = TMBarView.ButtonBar()
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 64.0, bottom: 4.0, right: 64.0)
        bar.layout.interButtonSpacing = 24.0
        bar.indicator.weight = .light
        bar.indicator.cornerStyle = .eliptical
        bar.fadesContentEdges = true
        bar.backgroundColor =  #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        bar.spacing = 16.0
        bar.buttons.customize {
            $0.tintColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
            $0.font = UIFont(name: "Graphik-Medium", size: 16)!
            $0.selectedTintColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1)
        }
        
        bar.indicator.tintColor = .clear
        addBar(bar.systemBar(), dataSource: self, at: .top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.navigationBar.isHidden = true
    }
}

extension MyProfileContainerVC  : PageboyViewControllerDataSource, TMBarDataSource{

func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
    if active {
    return viewControllers.count
    }else{
        return viewControllers2.count

    }
}

func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
    if active {
    return viewControllers[index]
    }else{
        return viewControllers2[index]

    }
}

func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
    return  nil
}

func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
    if active {
        if index == 0 {
            return TMBarItem(title:  "About")
        }else if index == 1  {
            return TMBarItem(title:  "Products")
        }else if index == 2 {
            return TMBarItem(title:  "Projects")
        }else if index == 3{
            return TMBarItem(title:  "Competitions")
        }else{
            return TMBarItem(title:  "Video")
        }
    }else{
         if index == 0{
            return TMBarItem(title:  "About")
        }else{
            return TMBarItem(title:  "Competitions")
        }
      }
    }
}

