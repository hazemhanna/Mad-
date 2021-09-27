//
//  AddProjectdetailsVc.swift
//  Mad
//
//  Created by MAC on 01/06/2021.
//


import UIKit
import DLRadioButton
import WSTagsField
import RxSwift
import RxCocoa
import PTCardTabBar


class AddProjectdetailsVc : UIViewController {

    @IBOutlet fileprivate weak var tagsViewHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var artistViewHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var tagsView: UIView!
    @IBOutlet fileprivate weak var artistView: UIView!
    @IBOutlet weak var short_description: CustomTextField!
    @IBOutlet weak var titleTF: CustomTextField!
    @IBOutlet weak var summeryTf: CustomTextField!
    @IBOutlet weak var startDateTf: CustomTextField!
    @IBOutlet weak var endDateTf: CustomTextField!
    @IBOutlet weak var locationTF: TextFieldDropDown!
    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var projectImage : UIImageView!
    

    var disposeBag = DisposeBag()
    var prjectVM = ProjectViewModel()
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    let cellIdentifier = "LiveCellCVC"
    var showShimmer: Bool = true

    var countries = [String]()
    var selectedIndex = -1
    var selectedCat = [Int]()
    var selectedArtist = [Int]()
    var selectedProducts = [Int]()
    var products = [Product]()
    
    var uploadedPhoto :UIImage?
    var start  = true
    var end = true
    
    fileprivate let tagsField = WSTagsField()
    fileprivate let artistField = WSTagsField()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        tagsField.cornerRadius = 3.0
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding
        tagsField.placeholder = ""
        tagsField.placeholderColor = .red
        tagsField.placeholderAlwaysVisible = true
        tagsField.backgroundColor = .clear
        tagsField.textField.returnKeyType = .continue
        tagsField.delimiter = ""
        tagsField.tintColor = #colorLiteral(red: 0.9058823529, green: 0.9176470588, blue: 0.937254902, alpha: 1)
        tagsField.textColor = #colorLiteral(red: 0.1749513745, green: 0.2857730389, blue: 0.4644193649, alpha: 1)
        tagsField.textDelegate = self
        textFieldEvents()

        artistField.frame = artistView.bounds
        artistView.addSubview(artistField)
        artistField.cornerRadius = 3.0
        artistField.spaceBetweenLines = 10
        artistField.spaceBetweenTags = 10
        artistField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        artistField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding
        artistField.placeholder = ""
        artistField.placeholderColor = .red
        artistField.placeholderAlwaysVisible = true
        artistField.backgroundColor = .clear
        artistField.textField.returnKeyType = .continue
        artistField.delimiter = ""
        artistField.tintColor = #colorLiteral(red: 0.9058823529, green: 0.9176470588, blue: 0.937254902, alpha: 1)
        artistField.textColor = #colorLiteral(red: 0.1749513745, green: 0.2857730389, blue: 0.4644193649, alpha: 1)
        artistField.textDelegate = self
        artistTextFieldEvents()

        self.liveCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self
        
        prjectVM.showIndicator()
        getProduct()
        getCountry()
        startDateTf.delegate = self
        endDateTf.delegate = self
        short_description.delegate = self
        titleTF.delegate = self
        summeryTf.delegate = self
        locationTF.delegate = self
    }
    

    
    func setupCountryDropDown(){
        locationTF.optionArray = self.countries
        locationTF.didSelect { (selectedText, index, id) in
            self.locationTF.text = selectedText
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        startDateTf.text = Helper.getDate1() ?? ""
        endDateTf.text = Helper.getDate2() ?? ""
        
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsField.frame = tagsView.bounds
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageButton(sender: UIButton) {
        showImageActionSheet()
    }
    
    @IBAction func calender1Button(sender: UIButton) {
        let vc = CalenderVc.instantiateFromNib()
        vc!.tag = 1
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func calender2Button(sender: UIButton) {
        let vc = CalenderVc.instantiateFromNib()
        vc!.tag = 2
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else {return}
        let vc = AboutProjectVC.instantiateFromNib()
        vc!.selectedCat = selectedCat
        vc!.selectedArtist = selectedArtist
        vc!.locationTF = locationTF.text ?? ""
        vc!.short_description = locationTF.text ?? ""
        vc!.titleTF = titleTF.text ?? ""
        vc!.summeryTf = summeryTf.text ?? ""
        vc!.startDateTf = startDateTf.text ?? ""
        vc!.endDateTf = endDateTf.text ?? ""
        vc!.uploadedPhoto = uploadedPhoto
        vc!.selectedProducts = selectedProducts
        vc!.products = products
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func validateInput() -> Bool {
        let tags =  self.selectedCat
        let titles = self.titleTF.text ?? ""
        let shortDescription = self.short_description.text ?? ""
        let summery = self.summeryTf.text ?? ""
        let startDate = self.startDateTf.text ?? ""
        let endDate = self.endDateTf.text ?? ""
        let location = self.locationTF.text ?? ""
        
        if tags.count == 0  {
          self.showMessage(text: "Please Choose Categeory")
          return false
        }else if tags.count > 3  {
            self.showMessage(text: "Please No More than 3 Categeory")
            return false
        }else if titles.isEmpty {
            self.showMessage(text: "Please Enter title")
            return false
        }else if shortDescription.isEmpty {
            self.showMessage(text: "Please Enter short Description")
            return false
        }else if summery.isEmpty {
            self.showMessage(text: "Please Enter summery")
            return false
        }else if startDate.isEmpty {
            self.showMessage(text: "Please Enter start date")
            return false
        }else if endDate.isEmpty {
            self.showMessage(text: "Please Enter end date")
            return false
        }else if location.isEmpty {
            self.showMessage(text: "Please Enter location")
            return false
        }else if uploadedPhoto == nil {
            self.showMessage(text: "Please upload image ")
            return false
        }else{
            return true
        }
    }
}

extension AddProjectdetailsVc: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startDateTf{
            if start {
            let vc = CalenderVc.instantiateFromNib()
            vc!.tag = 1
            self.start = false
            self.navigationController?.pushViewController(vc!, animated: true)
            }
        }else if textField == endDateTf{
            if end {
            let vc = CalenderVc.instantiateFromNib()
            vc!.tag = 2
            self.end = false
            self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
}

extension AddProjectdetailsVc {
    
    fileprivate func textFieldEvents() {
        
        tagsField.onDidAddTag = { field, tag in
            print("onDidAddTag", tag.text)
        }
        
        tagsField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
        }

        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")

            let vc = ArtistNameVC.instantiateFromNib()
            vc?.showArtist = false
            vc!.onClickCat = { cats in
             self.selectedCat.append(cats.id ?? 0 )
                self.tagsField.addTag(cats.name ?? "")
             self.presentingViewController?.dismiss(animated: true)
           }
           self.present(vc!, animated: true, completion: nil)
            
        }

        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
            self.tagsViewHeight.constant = height + 40

        }

        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }
        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
        tagsField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
    }
    
    fileprivate func artistTextFieldEvents() {
        
        artistField.onDidAddTag = { field, tag in
            print("onDidAddTag", tag.text)
        }
        
        artistField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
        }

        artistField.onDidChangeText = { _, text in
            print("onDidChangeText")
            let vc = ArtistNameVC.instantiateFromNib()
            vc?.showArtist = true
            vc!.onClickClose = { artist in
            self.selectedArtist.append(artist.id ?? 0)
            self.artistField.addTag(artist.name ?? "")
             self.presentingViewController?.dismiss(animated: true)
           }
           self.present(vc!, animated: true, completion: nil)
            
        }

        artistField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
            self.artistViewHeight.constant = height + 100
        }

        artistField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }
        artistField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
        artistField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
    }
}


// Number of columns

extension AddProjectdetailsVc {
    
    func getProduct(){
       prjectVM.getArtistProduct().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.products = dataModel.data ?? []
            self.liveCollectionView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
     func getCountry() {
            prjectVM.getAllCountries().subscribe(onNext: { (dataModel) in
                if dataModel.success ?? false {
                    self.prjectVM.dismissIndicator()
                    self.countries = dataModel.data ?? []
                    self.setupCountryDropDown()
                }
            }, onError: { (error) in
                self.prjectVM.dismissIndicator()

            }).disposed(by: disposeBag)
        }
}

extension AddProjectdetailsVc :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.showShimmer ? 3 : products.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LiveCellCVC
        if !self.showShimmer {
            
            cell.titleLabel.text = self.products[indexPath.row].title ?? ""
            cell.priceLbl.text = "\(self.products[indexPath.row].price ?? 0)"
            if let url = URL(string:   self.products[indexPath.row].imageURL ?? ""){
            cell.bannerImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Mask Group 56"))
            }

          if self.selectedIndex == indexPath.row{
            if  cell.mainView.layer.borderColor == #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1).cgColor{
                cell.mainView.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1).cgColor
                cell.mainView.layer.borderWidth = 0
                self.selectedProducts.removeAll{$0 == self.products[indexPath.row].id ?? 0}
            }else{
                cell.mainView.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.2235294118, blue: 0.3607843137, alpha: 1).cgColor
                cell.mainView.layer.borderWidth = 2
                self.selectedProducts.append(self.products[indexPath.row].id ?? 0 )

             }
            }
        }
        cell.showShimmer = showShimmer
        return cell
    }
    
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        liveCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    
        let size:CGFloat = (collectionView.frame.size.width - space) / 1.4
            return CGSize(width: size, height: (collectionView.frame.size.height))
        }
}


extension AddProjectdetailsVc : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImageActionSheet() {

        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
                self.showImagePicker(sourceType: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "Take a Picture from Camera", style: .default) { (action) in
                self.showImagePicker(sourceType: .camera)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            AlertService.showAlert(style: .actionSheet, title: "Pick Your Picture", message: nil, actions: [chooseFromLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            projectImage.isHidden = false
            projectImage.image = editedImage
            self.uploadedPhoto  = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            projectImage.isHidden = false
            projectImage.image = originalImage
            self.uploadedPhoto  = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}

