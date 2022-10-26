//
//  MyOrderVc.swift
//  Mad
//
//  Created by MAC on 06/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar


class MyOrderVc : UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let cellIdentifier = "MyOrderCell"
    let headerCellIdentifier = "ContentHeader"

    var showShimmer: Bool = false
    
    var disposeBag = DisposeBag()
    var orderVM = OrderViewModel()
    var ongoing = [History]()
    var history = [History]()

    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.register(UINib(nibName: headerCellIdentifier, bundle: nil), forCellReuseIdentifier: headerCellIdentifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrders()
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyOrderVc : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.showShimmer ? 1 : ongoing.count
        }else{
            return self.showShimmer ? 1 : history.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? ContentHeader else { return UITableViewCell()}
        if section == 0{
        cell.titleLbl.text = "Ongoing"
        }else{
        cell.titleLbl.text = "History"
        }
           return cell
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! MyOrderCell
        if !self.showShimmer {
            if indexPath.section == 0 {
                cell.confic(name: self.ongoing[indexPath.row].product?.title ?? "", productUrl: self.ongoing[indexPath.row].product?.imageURL ?? "", price: String(self.ongoing[indexPath.row].product?.price ?? 0), orderNum : String(self.ongoing[indexPath.row].orderID ?? 0) , artistName : self.ongoing[indexPath.row].product?.artist?.name ?? "" , artistUrl : self.ongoing[indexPath.row].product?.artist?.profilPicture ?? "")
            }else{
                cell.confic(name: self.history[indexPath.row].product?.title ?? "", productUrl: self.history[indexPath.row].product?.imageURL ?? "", price: String(self.history[indexPath.row].product?.price ?? 0), orderNum : String(self.history[indexPath.row].orderID ?? 0) , artistName : self.history[indexPath.row].product?.artist?.name ?? "" , artistUrl : self.history[indexPath.row].product?.artist?.profilPicture ?? "")

            }
        }
        cell.showShimmer = showShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let main = MyOrderDetailsVc.instantiateFromNib()
            main!.orderId = self.ongoing[indexPath.row].orderID ?? 0
            self.navigationController?.pushViewController(main!, animated: true)
        }else{
            let vc = ProductDetailsVC.instantiateFromNib()
            vc!.productId = self.history[indexPath.row].productID ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
    }
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
extension MyOrderVc {

func getOrders() {
    orderVM.getOrders().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.showShimmer = false
         //self.ongoing = dataModel.data?.ongoing ?? []
         self.ongoing = dataModel.data?.pending ?? []

        self.history = dataModel.data?.history ?? []
        self.tableView.reloadData()
       }
   }, onError: { (error) in

   }).disposed(by: disposeBag)
  }
}
