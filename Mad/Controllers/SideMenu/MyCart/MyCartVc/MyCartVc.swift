//
//  MyCartVc.swift
//  Mad
//
//  Created by MAC on 04/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar


class MyCartVc: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let cellIdentifier = "MyCartCell"
    var showShimmer: Bool = true
    
    open lazy var customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    var disposeBag = DisposeBag()
    var cartVM = CartViewModel()
    var cart = [Cart]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let ptcTBC = tabBarController as? PTCardTabBarController {
            ptcTBC.customTabBar.isHidden = true
        }
        
        self.cartVM.showIndicator()
        getCart()
        
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

extension MyCartVc: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showShimmer ? 1 : cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! MyCartCell
        if !self.showShimmer {
            cell.confic(name: self.cart[indexPath.row].product?.title ?? "" , productUrl:  self.cart[indexPath.row].product?.imageURL ?? "", price:  Int(self.cart[indexPath.row].product?.price ?? 0), count: String(self.cart[indexPath.row].quantity ?? 0))
            
            cell.plus = {
                let quantity = (self.cart[indexPath.row].quantity ?? 0)  + 1
                cell.countLbl.text = String(quantity)
                self.cartVM.showIndicator()
                self.updateCart(productId: self.cart[indexPath.row].product?.id ?? 0 , quantity: quantity)
            }
            
            cell.minus = {
                if self.cart[indexPath.row].quantity ?? 0 > 1{
                let quantity = (self.cart[indexPath.row].quantity ?? 0)  - 1
                cell.countLbl.text = String(quantity)
                self.cartVM.showIndicator()
                self.updateCart(productId: self.cart[indexPath.row].product?.id ?? 0 , quantity: quantity)
                }
            }
        }
        cell.showShimmer = showShimmer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = MyCartDetailsVc.instantiateFromNib()
        self.navigationController?.pushViewController(main!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension MyCartVc{
func getCart() {
    cartVM.getCart().subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.cartVM.dismissIndicator()
        self.showShimmer = false
        self.cart = dataModel.data?.cardProducts ?? []
        self.tableView.reloadData()
       }
   }, onError: { (error) in
    self.cartVM.dismissIndicator()
   }).disposed(by: disposeBag)
  }
    
    func updateCart(productId : Int,quantity :Int) {
        cartVM.updateCart(id:  productId,quantity:quantity).subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.getCart()
            self.cartVM.dismissIndicator()
           }
       }, onError: { (error) in
        self.cartVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }

    
}
