//
//  AboutProjectVC.swift
//  Mad
//
//  Created by MAC on 02/06/2021.
//

import UIKit
import SQRichTextEditor
import WebKit
import RxSwift
import RxCocoa

class AboutProjectVC: UIViewController {
    
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
    var selectedProducts = [Int]()
    var products = [Product]()
    var projectDetails : ProjectDetails?
    var projectContent = String()
    var prjectVM = ProjectViewModel()
    var disposeBag = DisposeBag()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.scrollDirection = .horizontal
        return _flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let _collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.translatesAutoresizingMaskIntoConstraints = false
        return _collectionView
    }()
    
    private lazy var editorView: SQTextEditorView = {
        let _editorView = SQTextEditorView()
        _editorView.delegate = self
        _editorView.translatesAutoresizingMaskIntoConstraints = false
        return _editorView
    }()
    
    private var selectedOption: ToolOptionType?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    
    override func viewDidLoad() {
     super.viewDidLoad()
        setupUI()
        setupCollectioView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.layoutIfNeeded()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(editorView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: ToolItemCellSettings.height).isActive = true
        
        editorView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        editorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        editorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        editorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
    }
    
    private func setupCollectioView() {
        collectionView.backgroundColor = .clear
        collectionView.register(ToolItemCell.self, forCellWithReuseIdentifier: ToolItemCellSettings.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //editorView.insertHTML(projectDetails?.content ?? "" , completion: nil)
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        if projectContent == ""{
            self.showMessage(text: "Please enter content of project")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        guard self.validateInput() else {return}
        let vc = CreatePackageVc.instantiateFromNib()
        vc!.selectedCat = selectedCat
        vc!.selectedArtist = selectedArtist
        vc!.locationTF = locationTF
        vc!.short_description = short_description
        vc!.titleTF = titleTF
        vc!.summeryTf = summeryTf
        vc!.startDateTf = startDateTf
        vc!.endDateTf = endDateTf
        vc!.contentHtml = projectContent
        vc!.uploadedPhoto = uploadedPhoto
        vc!.selectedProducts = selectedProducts
        vc!.products = products
        vc?.projectDetails = projectDetails
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    private lazy var colorPickerNavController: UINavigationController = {
        let colorSelectionController = EFColorSelectionViewController()
        colorSelectionController.delegate = self
        colorSelectionController.color = .black
        colorSelectionController.setMode(mode: .all)
        
        let nav = UINavigationController(rootViewController: colorSelectionController)
        if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
            let doneBtn: UIBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("Done", comment: ""),
                style: .done,
                target: self,
                action: #selector(dismissColorPicker)
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        
        return nav
    }()
    
    private func showColorPicker() {
        self.present(colorPickerNavController, animated: true, completion: nil)
    }
    
    @objc private func dismissColorPicker() {
        colorPickerNavController.dismiss(animated: true, completion: nil)
    }

    private func showInputAlert(type: ToolOptionType) {
        var textField: UITextField?
        let alertController = UIAlertController(title: type.description, message: nil, preferredStyle: .alert)
        alertController.addTextField { pTextField in
            pTextField.clearButtonMode = .whileEditing
            pTextField.borderStyle = .none
            textField = pTextField
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (pAction) in
            if let inputValue = textField?.text {
                switch type {
                case .makeLink:
                    self.editorView.makeLink(url: inputValue)
              //  case .insertImage:
                //    self.editorView.insertImage(url: inputValue)
                case .setTextSize:
                    self.editorView.setText(size: Int(inputValue) ?? 20)
                case .insertHTML:
                    self.editorView.insertHTML(inputValue)
                default:
                    break
                }
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showAlert(text: String?) {
        let alertController = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
extension AboutProjectVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ToolOptionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolItemCellSettings.id, for: indexPath)
        (cell as? ToolItemCell)?.configCell(option: ToolOptionType(rawValue: indexPath.row)!,
                                            attribute: editorView.selectedTextAttribute)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        selectedOption = ToolOptionType(rawValue: indexPath.row)
        if let option = selectedOption {
            switch option {
            case .bold:
                editorView.bold()
            case .italic:
                editorView.italic()
            case .strikethrough:
                editorView.strikethrough()
            case .underline:
                editorView.underline()
            case .clear:
                editorView.clear()
            case .removeLink:
                editorView.removeLink()
            case .setTextColor, .setTextBackgroundColor:
                showColorPicker()
            case .insertHTML, .makeLink, .setTextSize:
                showInputAlert(type: option)
            case .insertImage:
                showImageActionSheet()
            case .getHTML:
                editorView.getHTML { html in
                    self.showAlert(text: html)
                    self.projectContent = html ?? ""
                }
            case .focusEditor:
                editorView.focus(true)
            case .blurEditor:
                editorView.focus(false)
            case .getHeight:
                break
            }
        }
    }
}

extension AboutProjectVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let option = ToolOptionType(rawValue: indexPath.row) else { return .zero }
        let width = option.description.size(withAttributes: [.font: ToolItemCellSettings.normalfont]).width + 15
        return CGSize(width: width, height: ToolItemCellSettings.height)
    }
}

extension AboutProjectVC: SQTextEditorDelegate {
    func editorDidLoad(_ editor: SQTextEditorView) {
        print("editorDidLoad")
    }
    
    func editor(_ editor: SQTextEditorView, selectedTextAttributeDidChange attribute: SQTextAttribute) {
        collectionView.reloadData()
    }
    
    func editor(_ editor: SQTextEditorView, contentHeightDidChange height: Int) {
        print("contentHeightDidChange = \(height)")
    }
    
    func editorDidFocus(_ editor: SQTextEditorView) {
        print("editorDidFocus")
    }
    
    func editor(_ editor: SQTextEditorView, cursorPositionDidChange position: SQEditorCursorPosition) {
        print(position)
    }
    
    func editorDidTapDoneButton(_ editor: SQTextEditorView) {
        print("editorDidTapDoneButton")
        editorView.getHTML { html in
           self.projectContent = html ?? ""
         }
    }
    
}

extension AboutProjectVC: EFColorSelectionViewControllerDelegate {
        func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        if let option = selectedOption {
            switch option {
            case .setTextColor:
                editorView.setText(color: color)
            case .setTextBackgroundColor:
                editorView.setText(backgroundColor: color)
            default:
                break
            }
        }
    }
}

extension AboutProjectVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            self.editorView.insertImage(url: "https://images.app.goo.gl/khgwNLPEo83r5CUt5")
            //uploadImage(image : editedImage)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.editorView.insertImage(url: "https://images.app.goo.gl/khgwNLPEo83r5CUt5")
            //uploadImage(image : originalImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(image : UIImage) {
        self.prjectVM.showIndicator()
        prjectVM.updateProfile(image: image).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.prjectVM.dismissIndicator()
               self.editorView.insertImage(url: "https://images.app.goo.gl/khgwNLPEo83r5CUt5")
           }
       }, onError: { (error) in
        self.prjectVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}
