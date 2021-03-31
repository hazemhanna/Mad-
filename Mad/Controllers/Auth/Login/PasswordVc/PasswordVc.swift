//
//  PasswordVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit

class PasswordVc: UIViewController {
   
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var lineImage: UIImageView!
    @IBOutlet weak var resetLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ResetTapAction(_:)))
        resetLbl.isUserInteractionEnabled = true
        resetLbl.addGestureRecognizer(gestureRecognizer)
        setupMultiColorRegisterLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    var showOld  = false
    @IBAction func showOldActions(_ sender: UIButton) {
              if showOld ==  false  {
                  self.passwordTF.isSecureTextEntry = false
                  lineImage.isHidden = true
                  showOld = true
              }else{
                self.passwordTF.isSecureTextEntry = true
                lineImage.isHidden = false
                showOld = false
              }
      }

    
    //MARK:- Register Label Action Configurations
    @objc func ResetTapAction(_ sender: UITapGestureRecognizer) {
       print("true")
    }
    
    
    func setupMultiColorRegisterLabel() {
        let main_string = "Forgot PASSWORD? Reset Now"
        let coloredString = "Reset Now"
        let Range = (main_string as NSString).range(of: coloredString)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1) , range: Range)
        resetLbl.attributedText = attribute
    }
    
}
