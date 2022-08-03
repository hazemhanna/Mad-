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
    

    @IBOutlet weak var title1TF: CustomTextField!
    @IBOutlet weak var title2TF: CustomTextField!
    @IBOutlet weak var title3TF: CustomTextField!
    
    @IBOutlet weak var description1TF : CustomTextField!
    @IBOutlet weak var description2TF : CustomTextField!
    @IBOutlet weak var description3TF : CustomTextField!

    @IBOutlet weak var price1: UITextField!
    @IBOutlet weak var price2: UITextField!
    @IBOutlet weak var price3: UITextField!
    
    @IBOutlet weak var price_eur1: UITextField!
    @IBOutlet weak var price_eur2: UITextField!
    @IBOutlet weak var price_eur3: UITextField!
    
    var projectDetails : ProjectDetails?

    
    var selectedCat = [Int]()
    var selectedArtist = [String]()
    var locationTF = String()
    var short_description = String()
    var titleTF = String()
    var summeryTf = String()
    var startDateTf = String()
    var endDateTf = String()
    var contentHtml = String()
    var uploadedPhoto :UIImage?
    var package1 = [String:String]()
    var package2 = [String:String]()
    var package3 = [String:String]()
    var packages = [[String:String]]()
    var selectedProducts = [Int]()
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Package1Stack.isHidden = false
        Package2Stack.isHidden = true
        Package3Stack.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
       self.view.addGestureRecognizer(gesture)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        packages.removeAll()
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
        title1TF.text = projectDetails?.package1?.title ?? ""
        title2TF.text = projectDetails?.package2?.title ?? ""
        title3TF.text = projectDetails?.package3?.title ?? ""
        description1TF.text = projectDetails?.package1?.descriptionss ?? ""
        description2TF.text = projectDetails?.package2?.descriptionss ?? ""
        description3TF.text = projectDetails?.package3?.descriptionss ?? ""
        price1.text = String(projectDetails?.package1?.price ?? 0)
        price2.text =  String(projectDetails?.package2?.price ?? 0)
        price3.text =  String(projectDetails?.package3?.price ?? 0)
        price_eur1.text = String(projectDetails?.package1?.price_eur ?? 0)
        price_eur2.text =  String(projectDetails?.package2?.price_eur ?? 0)
        price_eur3.text =  String(projectDetails?.package3?.price_eur ?? 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        if package1.count < 0 && package2.count < 0 && package3.count < 0  {
            self.showMessage(text: "Please enter one package at least")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else {return}
        package1["title"] = title1TF.text ?? ""
        package2["title"] = title2TF.text ?? ""
        package3["title"] = title3TF.text ?? ""
        
        package1["description"] = description1TF.text ?? ""
        package2["description"] = description2TF.text ?? ""
        package3["description"] = description3TF.text ?? ""
        
        package1["price"] = price1.text ?? ""
        package2["price"] = price2.text ?? ""
        package3["price"] = price3.text ?? ""
        
        package1["price_eur"] = price_eur1.text ?? ""
        package2["price_eur"] = price_eur2.text ?? ""
        package3["price_eur"] = price_eur3.text ?? ""
        
        
        if title1TF.text  != "" || description1TF.text != ""  || price1.text != "0"  || price_eur1.text != "0"  {
            packages.append(package1)
        }

        if title2TF.text  != "" || description2TF.text != ""  || price2.text != "0"  || price_eur2.text != "0"  {
            packages.append(package2)
        }
        
        if title3TF.text  != "" || description3TF.text != ""  || price3.text != "0"  || price_eur3.text != "0"  {
            packages.append(package3)
        }
        
        let vc = PreviewProjectVc.instantiateFromNib()
        vc!.selectedCat = selectedCat
        vc!.selectedArtist = selectedArtist
        vc!.locationTF = locationTF
        vc!.short_description = short_description
        vc!.titleTF = titleTF
        vc!.summeryTf = summeryTf
        vc!.startDateTf = startDateTf
        vc!.endDateTf = endDateTf
        vc!.contentHtml = contentHtml
        vc!.uploadedPhoto = uploadedPhoto
        vc!.packages = packages
        vc!.selectedProducts = selectedProducts
        vc!.products = products
        vc?.projectDetails = projectDetails
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

