//
//  LoadingLoginVc.swift
//  Mad
//
//  Created by MAC on 30/03/2021.
//

import Foundation

import UIKit

class LoadingLoginVc : UIViewController {
    
    @IBOutlet weak var JoinMaderleLbl : UIButton!
    @IBOutlet weak var JoinArtistleLbl : UIButton!
    @IBOutlet weak var SKIPleLbl : UIButton!
    @IBOutlet weak var Login : UIButton!
    @IBOutlet weak var registerBtn : UIButton!
    @IBOutlet weak var goBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localized()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func localized(){
        JoinMaderleLbl.setTitle("Join.MADer".localized, for: .normal)
        JoinArtistleLbl.setTitle("Join.artist".localized, for: .normal)
        SKIPleLbl.setTitle("SKIP.EXPLORE".localized, for: .normal)
        Login.setTitle("Login".localized, for: .normal)
        registerBtn.setTitle("Mad.artist".localized, for: .normal)
        goBtn.setTitle("Go".localized, for: .normal)

    }
    
    @IBAction func loginButton(sender: UIButton) {
        let main = EmailVc.instantiateFromNib()
        Helper.saveType(type: false)
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func joinArtistButton(sender: UIButton) {
        let main = EmailVc.instantiateFromNib()
         Helper.saveType(type: true)
        self.navigationController?.pushViewController(main!, animated: true)
        
    }
    
    @IBAction func goButton(sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardTabBarController")
        if let appDelegate = UIApplication.shared.delegate {
            appDelegate.window??.rootViewController = sb
        }
    }
}
