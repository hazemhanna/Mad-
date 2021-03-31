//
//  LoadingLoginVc.swift
//  Mad
//
//  Created by MAC on 30/03/2021.
//

import Foundation

import UIKit

class LoadingLoginVc : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func loginButton(sender: UIButton) {
        let main = EmailVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func joinMaderButton(sender: UIButton) {
        let main = EmailVc.instantiateFromNib()
        main?.register = true
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func joinArtistButton(sender: UIButton) {
        let main = EmailVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    @IBAction func loginArtistButton(sender: UIButton) {
        let main = EmailVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func goButton(sender: UIButton) {
        let main = EmailVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
}
