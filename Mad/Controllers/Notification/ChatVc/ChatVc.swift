//
//  ChatVc.swift
//  Mad
//
//  Created by MAC on 27/07/2021.
//



import UIKit
import DLRadioButton
import WSTagsField
import RxSwift
import RxCocoa
import PTCardTabBar


class ChatVc: UIViewController {
    
    @IBOutlet fileprivate weak var chatTableView : UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messegtTF: UITextField!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var inputContainView: UIView!
    
    var disposeBag = DisposeBag()
    var ChatVM = ChatViewModel()
    private let cellIdentifier = "ChatCell"
    var userId = Helper.getId() ?? 0
    var fName = Helper.getFName() ?? ""
    var lName = Helper.getLName() ?? ""
    var profile = Helper.getprofile() ?? ""
    var messages : [Messages] = []
    var convId = Int()
    
    var objectName = String()
    var objectImage = String()
    var objectPrice = String()

    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatTableView()
        addKeyboardObserver()
        messegtTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
        ChatVM.showIndicator()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllMessages(convId: convId)
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButton(sender: UIButton) {
        if messegtTF.text!.isEmpty{
            self.showMessage(text: "type your message")
        }else{
            ChatVM.showIndicator()
            sendMessages(convId: self.convId, content: messegtTF.text ?? "")
        }
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardFrameWillChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let endKeyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
                return
        }
        
        let endKeyboardFrame = endKeyboardFrameValue.cgRectValue
        let duration = durationValue.doubleValue
        
        let isShowing: Bool = endKeyboardFrame.maxY > UIScreen.main.bounds.height ? false : true
        
        UIView.animate(withDuration: duration) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if isShowing {
                let offsetY = strongSelf.inputContainView.frame.maxY - endKeyboardFrame.minY
                guard offsetY > 0 else {
                    return
                }
                strongSelf.inputViewBottom.constant = -offsetY
            } else {
                strongSelf.inputViewBottom.constant = 0
            }
            strongSelf.view.layoutIfNeeded()
        }
    }
}

extension ChatVc: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension ChatVc : UITableViewDelegate,UITableViewDataSource{
    
        func setupChatTableView() {
            chatTableView.delegate = self
            chatTableView.dataSource = self
            self.chatTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
            self.chatTableView.rowHeight = UITableView.automaticDimension
            self.chatTableView.estimatedRowHeight = UITableView.automaticDimension
        }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! ChatCell
        let msg = messages[indexPath.row].content ?? ""
        let ReceiverFlag: Bool?
        var name = String()
        var image = String()
        name = messages[indexPath.row].user?.name ?? ""
        image = messages[indexPath.row].user?.profilPicture ?? ""
        
        if indexPath.row == 0 {
            cell.productContentView.isHidden = false
            if  let projectUrl = URL(string: objectImage){
            cell.productImage.kf.setImage(with: projectUrl, placeholder: #imageLiteral(resourceName: "Le_Botaniste_Le_Surveillant_Dhorloge_Reseaux_4"))
            }
            cell.productNameLbl.text = objectName
            if self.objectPrice != "" {
                cell.priceLbl.text = self.objectPrice
                cell.priceLbl.isHidden = false
            }else{
                cell.priceLbl.isHidden = true
            }
            
        }else{
            cell.productContentView.isHidden = true
        }
        if self.userId == messages[indexPath.row].user?.id ?? 0 {
            ReceiverFlag = false
        }else{
            ReceiverFlag = true
        }
        cell.config(Message: msg, ReceiverFlag: ReceiverFlag ?? false , name: name,image: image)
        return cell
    }
}

extension ChatVc {
    func getAllMessages(convId : Int) {
        ChatVM.getMessages(convId: convId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.ChatVM.dismissIndicator()
            self.messages = dataModel.data ?? []
            self.messages.insert(Messages(id: 0, user: (Artist(id: self.userId, name: self.fName + " " + self.lName , headline: "", profilPicture: self.profile, bannerImg: "", allFollowers: 0, allFollowing: 0, isFavorite: false, music: false, art: false, design: false, isMadProfile: false)), destinataire: nil, content: nil, attachement: nil, date: nil, seen: nil) , at : 0)
            self.chatTableView.reloadData()

            if self.messages.count > 0 {
            let end = IndexPath(row: self.messages.count - 1, section: 0)
            self.chatTableView.scrollToRow(at: end, at: .bottom, animated: true)
            }
         }
       }, onError: { (error) in
        self.ChatVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
    
    
    func sendMessages(convId : Int,content :String) {
        ChatVM.sendMessages(content: content, convId: convId).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.getAllMessages(convId : convId)
            self.chatTableView.reloadData()
            self.messegtTF.text = ""
           }
       }, onError: { (error) in
        self.ChatVM.dismissIndicator()

       }).disposed(by: disposeBag)
   }
}



