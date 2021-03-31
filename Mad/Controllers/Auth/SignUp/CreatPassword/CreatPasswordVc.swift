//
//  CreatPasswordVc.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//

import UIKit

class CreatPasswordVc: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var iconImage : UIImageView!
    @IBOutlet weak var passwordTF : CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButton(sender: UIButton) {
        let main = NameVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }

    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwordTF.text?.count ?? 0 > 7 {
            iconImage.isHidden = false
        }else{
            iconImage.isHidden = true
        }
    }
}
