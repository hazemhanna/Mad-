//
//  SubmitCopetitionsVC.swift
//  Mad
//
//  Created by MAC on 18/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class SubmitCopetitionsVC: UIViewController {

    @IBOutlet weak var presentTf: CustomTextField!
    @IBOutlet weak var socialTF: TextFieldDropDown!
    
    var competitionVm = CometitionsViewModel()
    var disposeBag = DisposeBag()
    var compId = Int()
    var uploadImage = UIImage()
    var firstName = String()
    var lastName = String()
    var phoneNumber = String()
    var email = String()
    var artistName = String()
    var personal = String()
    var linke = String()
    var social = [String]()
    var socialLinks = [SocialModel]()
   // var selectedSocial = String()
    var candidate:Candidate?

    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSocial()
        presentTf.delegate = self
        socialTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController{
            ptcTBC.customTabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.presentTf.text = candidate?.introductionFile ?? ""
        self.socialTF.text = candidate?.knowAbout ?? ""
    }
    
    func setupsocialDropDown(){
        socialTF.optionArray = self.social
        socialTF.didSelect { (selectedText, index, id) in
            self.socialTF.text = selectedText
           // self.selectedSocial = self.socialLinks[index].key ?? ""
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateInput() -> Bool {
        let present = self.presentTf.text ?? ""
        let social = self.socialTF.text ?? ""
        if present.isEmpty {
            self.showMessage(text: "Please What do you want to present")
            return false
        }else if social.isEmpty {
            self.showMessage(text: "Please Enter where you konw about us")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func saveButton(sender: UIButton) {
       // guard self.validateInput() else {return}
        self.competitionVm.showIndicator()
        if let id = candidate?.id {
            saveCompete(candidat_id: id, competitionId: compId, fName: firstName, lName: lastName, phone: phoneNumber, email: email, personal: personal, artist_name: artistName, video_link: linke, project_description: self.presentTf.text  ?? "", know_about:  self.socialTF.text ?? "" , submit: "draft", file: uploadImage)
        }else{
        addCompete(competitionId: compId, fName: firstName, lName: lastName, phone: phoneNumber, email: email, personal: personal, artist_name: artistName, video_link: linke, project_description: self.presentTf.text  ?? "", know_about:  self.socialTF.text ?? "", submit: "draft", file: uploadImage)
        }
    }

    @IBAction func submitButton(sender: UIButton) {
        guard self.validateInput() else {return}
        self.competitionVm.showIndicator()
        addCompete(competitionId: compId, fName: firstName, lName: lastName, phone: phoneNumber, email: email, personal: personal, artist_name: artistName,  video_link: linke, project_description: self.presentTf.text  ?? "", know_about:  self.socialTF.text  ?? "" , submit: "submit", file: uploadImage)
    }
}

extension SubmitCopetitionsVC{
    func getSocial() {
        competitionVm.getAboutCompetitionsl().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.competitionVm.dismissIndicator()
            self.socialLinks = dataModel.data ?? []
            for index in self.socialLinks {
                self.social.append(index.value ?? "")
            }
            self.setupsocialDropDown()
           }
       }, onError: { (error) in
        self.competitionVm.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    func addCompete(competitionId :Int,
                    fName :String,
                    lName :String,
                    phone:String,
                    email:String,
                    personal:String,
                    artist_name:String,
                    video_link:String,
                    project_description:String,
                    know_about:String,
                    submit:String,
                    file :UIImage) {
        competitionVm.CreateCompete(competitionId: competitionId, fName: fName, lName: lName, phone: phone, email: email, personal: personal, artist_name: artist_name,video_link: video_link, project_description: project_description, know_about: know_about, submit: submit, file: file).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.competitionVm.dismissIndicator()
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
           }else{
            self.competitionVm.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.competitionVm.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    
    func saveCompete(candidat_id : Int,
                    competitionId :Int,
                    fName :String,
                    lName :String,
                    phone:String,
                    email:String,
                    personal:String,
                    artist_name:String,
                    video_link:String,
                    project_description:String,
                    know_about:String,
                    submit:String,
                    file :UIImage) {
        competitionVm.saveCompete(candidat_id: candidat_id, competitionId: competitionId, fName: fName, lName: lName, phone: phone, email: email, personal: personal, artist_name: artist_name,video_link: video_link, project_description: project_description, know_about: know_about, submit: submit, file: file).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.competitionVm.dismissIndicator()
            displayMessage(title: "",message: dataModel.message ?? "", status: .success, forController: self)
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
           }else{
            self.competitionVm.dismissIndicator()
            self.showMessage(text: dataModel.message ?? "")
           }
       }, onError: { (error) in
        self.competitionVm.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    
    
    
}

extension SubmitCopetitionsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
