//
//  AboutProjectVC.swift
//  Mad
//
//  Created by MAC on 02/06/2021.
//

import UIKit
import RichEditorView

class AboutProjectVC: UIViewController {
    
    @IBOutlet var editorView: RichEditorView!
    @IBOutlet var htmlTextView: UITextView!
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()
    
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

    override func viewDidLoad() {
     super.viewDidLoad()
   
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar
        editorView.placeholder = "Type some text..."

        toolbar.delegate = self
        toolbar.editor = editorView

        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }

        var options = toolbar.options
        options.append(item)
        toolbar.options = options
        
       let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
       self.view.addGestureRecognizer(gesture)
           
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        htmlTextView.text = projectDetails?.content ?? ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        if htmlTextView.text  == ""{
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
        vc!.contentHtml = htmlTextView.text ?? ""
        vc!.uploadedPhoto = uploadedPhoto
        vc!.selectedProducts = selectedProducts
        vc!.products = products
        vc?.projectDetails = projectDetails
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension AboutProjectVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
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
            
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
        }
        dismiss(animated: true, completion: nil)
    }
    
}



extension AboutProjectVC: RichEditorDelegate {

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            htmlTextView.text = "HTML Preview"
        } else {
            htmlTextView.text = content
        }
    }
    
}

extension AboutProjectVC: RichEditorToolbarDelegate {

    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        self.showImagePicker(sourceType: .photoLibrary)
        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }
    
    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if toolbar.editor?.hasRangeSelection == true {
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
}
