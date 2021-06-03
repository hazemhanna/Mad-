//
//  CreatePackageVc.swift
//  Mad
//
//  Created by MAC on 02/06/2021.
//

import UIKit

class CreatePackageVc: UIViewController {

    @IBOutlet weak var Package1Stack : UIStackView!
    @IBOutlet weak var Package2Stack : UIStackView!
    @IBOutlet weak var Package3Stack : UIStackView!
    @IBOutlet weak var Package1Btn : UILabel!
    @IBOutlet weak var Package2Btn : UILabel!
    @IBOutlet weak var Package3Btn : UILabel!
    @IBOutlet weak var plus1Btn : UIButton!
    @IBOutlet weak var plus2Btn : UIButton!
    @IBOutlet weak var Plus3Btn : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Package1Stack.isHidden = false
        Package2Stack.isHidden = true
        Package3Stack.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        Package1Btn.textColor = #colorLiteral(red: 0.2196078431, green: 0.5137254902, blue: 0.8588235294, alpha: 1)
        plus1Btn.setTitle( "-", for: .normal)
        plus1Btn.setTitleColor(#colorLiteral(red: 0.2196078431, green: 0.5137254902, blue: 0.8588235294, alpha: 1), for: .normal)
        
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

    
    @IBAction func PackageButton(sender: UIButton) {
        if sender.tag == 1 {
            Package1Stack.isHidden = false
            Package2Stack.isHidden = true
            Package3Stack.isHidden = true
            
             Package1Btn.textColor = #colorLiteral(red: 0.2196078431, green: 0.5137254902, blue: 0.8588235294, alpha: 1)
             Package2Btn.textColor = #colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1)
             Package3Btn.textColor = #colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1)
            
             plus1Btn.setTitle( "-", for: .normal)
             plus1Btn.setTitleColor(#colorLiteral(red: 0.2196078431, green: 0.5137254902, blue: 0.8588235294, alpha: 1), for: .normal)
             plus2Btn.setTitle( "+", for: .normal)
             plus2Btn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
             Plus3Btn.setTitle( "+", for: .normal)
             Plus3Btn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            
        }else if sender.tag == 2 {
            Package1Stack.isHidden = true
            Package2Stack.isHidden = false
            Package3Stack.isHidden = true
            
            Package1Btn.textColor =  #colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1)
            Package2Btn.textColor = #colorLiteral(red: 0.2196078431, green: 0.5137254902, blue: 0.8588235294, alpha: 1)
            Package3Btn.textColor = #colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1)
            
            plus1Btn.setTitle( "+", for: .normal)
            plus1Btn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            plus2Btn.setTitle( "-", for: .normal)
            plus2Btn.setTitleColor(#colorLiteral(red: 0.2196078431, green: 0.5137254902, blue: 0.8588235294, alpha: 1), for: .normal)
            Plus3Btn.setTitle( "+", for: .normal)
            Plus3Btn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            
        }else if sender.tag == 3 {
            
            Package1Stack.isHidden = true
            Package2Stack.isHidden = true
            Package3Stack.isHidden = false
            
            Package1Btn.textColor =  #colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1)
            Package2Btn.textColor = #colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1)
            Package3Btn.textColor = #colorLiteral(red: 0.2196078431, green: 0.5137254902, blue: 0.8588235294, alpha: 1)
            
            plus1Btn.setTitle( "+", for: .normal)
            plus1Btn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            plus2Btn.setTitle( "+", for: .normal)
            plus2Btn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.2156862745, blue: 0.3882352941, alpha: 1), for: .normal)
            Plus3Btn.setTitle( "-", for: .normal)
            Plus3Btn.setTitleColor(#colorLiteral(red: 0.2196078431, green: 0.5137254902, blue: 0.8588235294, alpha: 1), for: .normal)
            
        }
    }

    
    

}
