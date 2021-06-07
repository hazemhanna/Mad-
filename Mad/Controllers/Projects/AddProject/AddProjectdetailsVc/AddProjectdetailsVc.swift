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
    @IBOutlet weak var locationTF: CustomTextField!

    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var projectImage : UIImageView!

    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    let cellIdentifier = "LiveCellCVC"
    
    var disposeBag = DisposeBag()
    var prjectVM = ProjectViewModel()
    var categeory = [Category]()
    var artist = [Artist]()

    var selectedCat = [Int]()
    var selectedArtist = [Int]()
    
    var catArray = [String]()
    var artistArray = [String]()
    var categeoryStrings = [String]()
    var filterArtistArray = [String]()
    
    var uploadedPhoto :UIImage?
    
    fileprivate let tagsField = WSTagsField()
    fileprivate let artistField = WSTagsField()
    var typePickerView: UIPickerView = UIPickerView()
    var artistPickerView: UIPickerView = UIPickerView()

    
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

        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
        self.liveCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self
        
        prjectVM.showIndicator()
        getCategory()
        getAllArtist(pageNum: 1)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        self.typePickerView.isHidden = true
        view.endEditing(true)
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
        tagsField.beginEditing()
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
        self.selectedCat.removeAll()
        let tags = tagsField.tags.map({$0.text})
        let uniqTags = tags.uniqued()
        for index in uniqTags{
                for cat in self.categeory{
                    if index == cat.name{
                        self.selectedCat.append(cat.id ?? 0)
                    }
                }
            }
        
        self.selectedArtist.removeAll()
        let tags2 = artistField.tags.map({$0.text})
        let uniqTags2 = tags2.uniqued()
        for index in uniqTags2{
                for i in self.artist{
                    if index == i.name{
                        self.selectedArtist.append(i.id ?? 0)
                }
            }
        }
        
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
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    
    func validateInput() -> Bool {
        let tags =  self.selectedCat
        let tags2 = self.selectedArtist
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
        } else if tags2.count == 0  {
            self.showMessage(text: "Please Choose Artist")
            return false
          }else if tags2.count > 3  {
              self.showMessage(text: "Please No More than 3 Artist")
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagsField {
            self.typePickerView.isHidden = true
        }
        return true
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

            self.categeoryStrings = self.catArray.filter({return $0.contains(text ?? "")})
            self.view.addSubview(self.typePickerView)
            self.typePickerView.frame = CGRect(x: 200, y: 320, width: 150, height: 160)
            self.typePickerView.delegate = self
            self.typePickerView.dataSource = self
            self.typePickerView.isHidden = false
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

            self.filterArtistArray = self.artistArray.filter({return $0.contains(text ?? "")})
            self.view.addSubview(self.artistPickerView)
            self.artistPickerView.frame = CGRect(x: 200, y: 400, width: 150, height: 160)
            self.artistPickerView.delegate = self
            self.artistPickerView.dataSource = self
            self.artistPickerView.isHidden = false
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
extension AddProjectdetailsVc : UIPickerViewDelegate, UIPickerViewDataSource {

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}
// Number of rows

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView ==  artistPickerView{
    return filterArtistArray.count
    }else {
        return categeoryStrings.count
    }
}
    
func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView ==  artistPickerView{
        return filterArtistArray[row]
    }else {
        return categeoryStrings[row]
    }
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView ==  artistPickerView{
        artistField.addTag(filterArtistArray[row])
        self.artistPickerView.isHidden = true
    }else {
        tagsField.addTag(categeoryStrings[row])
        self.typePickerView.isHidden = true
     }
   }
}

extension AddProjectdetailsVc {
     func getCategory() {
        prjectVM.getCategories().subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
                self.prjectVM.dismissIndicator()
                self.categeory = dataModel.data ?? []
                for cat in self.categeory{
                    self.catArray.append(cat.name ?? "")
                }
            }
        }, onError: { (error) in
            self.prjectVM.dismissIndicator()

        }).disposed(by: disposeBag)
    }
    
    func getAllArtist(pageNum : Int) {
        prjectVM.getAllArtist(pageNum : pageNum).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.artist = dataModel.data?.data ?? []
            for index in self.artist {
                self.artistArray.append(index.name ?? "")
            }
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
}

extension AddProjectdetailsVc :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LiveCellCVC
        cell.showShimmer = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
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
