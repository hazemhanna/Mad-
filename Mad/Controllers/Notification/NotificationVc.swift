//
//  NotificationVc.swift
//  Mad
//
//  Created by MAC on 02/04/2021.
//

import UIKit
import RxSwift
import RxCocoa


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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        messageView.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
        return 4
     }else{
         return 8
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == notificationTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! NotificationCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier2) as! InboxCell
            return cell
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
