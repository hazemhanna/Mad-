//
//  AboutVc.swift
//  Mad
//
//  Created by MAC on 23/04/2021.
//

import UIKit

class AboutVc: UIViewController {

    @IBOutlet weak var  facebookName: UILabel!
    @IBOutlet weak var  instgramName: UILabel!
    @IBOutlet weak var  twitterName: UILabel!
    @IBOutlet weak var  levelLbl: UILabel!
    @IBOutlet weak var  pointLbl: UILabel!
    @IBOutlet weak var  bioLbTextView : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    
    }
    
    
    @IBAction func didClickFacebookLink(){
        let url = ""
        Helper.UIApplicationURL.openUrl(url: url)
    }
    
    @IBAction func didClickTwitterLink(){
        let url = ""
        Helper.UIApplicationURL.openUrl(url: url)
    }
 
    @IBAction func didClickInstgramlinl(){
        let url =  ""
        Helper.UIApplicationURL.openUrl(url: url)
    }
    
}
