//
//  NotificationVc.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar


class NotificationVc: UIViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var inboxTableView: UITableView!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var indexBtn: UIButton!
    @IBOutlet weak var indexView: UIView!
    @IBOutlet weak var messageView: UIView!
    
    private let cellIdentifier = "NotificationCell"
    private let cellIdentifier2 = "InboxCell"
    
    var chatVM = ChatViewModel()
    var disposeBag = DisposeBag()
    var showShimmer: Bool = true

    
    var inbox = [Inbox]()
    var notifications = [Notifications]()

    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
        messageView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        getNotification()
        getInbox()
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func sendMessageAction(sender: UIButton) {
        let main = SendMessageVc.instantiateFromNib()
        main?.artistId = 0
        main?.fromArtistPage = false
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    
    @IBAction func notificationBtn(sender: UIButton) {
        if sender.tag == 1 {
            indexView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9058823529, blue: 0.9568627451, alpha: 1)
            notificationView.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1)
            indexBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            notificationBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            notificationTableView.isHidden = false
            inboxTableView.isHidden = true
            messageView.isHidden = true
            
        }else{
            notificationView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9058823529, blue: 0.9568627451, alpha: 1)
            indexView.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1)
            notificationBtn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1), for: .normal)
            indexBtn.setTitleColor(#colorLiteral(red: 0.8980392157, green: 0.1254901961, blue: 0.3529411765, alpha: 1), for: .normal)
            inboxTableView.isHidden = false
            notificationTableView.isHidden = true
            messageView.isHidden = false
        }
    }
}

extension NotificationVc : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        self.notificationTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        
        inboxTableView.delegate = self
        inboxTableView.dataSource = self
        self.inboxTableView.register(UINib(nibName: self.cellIdentifier2, bundle: nil), forCellReuseIdentifier: self.cellIdentifier2)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     if tableView == notificationTableView {
        return notifications.count
     }else{
        return inbox.count
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == notificationTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! NotificationCell
            if !showShimmer{
                cell.confic(date: self.notifications[indexPath.row].createdAt ?? "" , artistUrl: self.notifications[indexPath.row].imageURL ?? "", content: self.notifications[indexPath.row].body?.html2String ?? "")
            }
            cell.showShimmer = showShimmer
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier2) as! InboxCell
            if !showShimmer{
                cell.confic(name: self.inbox[indexPath.row].object?.artist?.name ?? "" , artistUrl: self.inbox[indexPath.row].object?.artist?.profilPicture ?? "", content: self.inbox[indexPath.row].body ?? "")
            }
            cell.showShimmer = showShimmer
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == notificationTableView {
        
        }else{
            let main = ChatVc.instantiateFromNib()
            main?.convId = self.inbox[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(main!, animated: true)
        }
    }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     if tableView == notificationTableView {
        return 100
     }else{
        return 90
        }
    }
}

extension NotificationVc{
    func getInbox() {
        chatVM.getConversation().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.inbox = dataModel.data?.inbox ?? []
            self.inboxTableView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
    func getNotification() {
        chatVM.getNotifications().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.showShimmer = false
            self.notifications = dataModel.data ?? []
            self.notificationTableView.reloadData()
           }
       }, onError: { (error) in

       }).disposed(by: disposeBag)
   }
    
}
