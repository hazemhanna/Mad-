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

    var disposeBag = DisposeBag()
    var ChatVM = ChatViewModel()
    private let cellIdentifier = "ChatCell"
    var userId = Helper.getId() ?? 0
    var messages : [Messages] = []
    var convId = Int()
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatTableView()
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
        if userId == messages[indexPath.row].user?.id ?? 0 {
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
            self.chatTableView.reloadData()
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



