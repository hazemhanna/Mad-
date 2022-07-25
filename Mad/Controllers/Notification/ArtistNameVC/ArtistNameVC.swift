//
//  ArtistNameVC.swift
//  Mad
//
//  Created by MAC on 27/09/2021.
//

import UIKit
import RxSwift
import RxCocoa
import PTCardTabBar

class ArtistNameVC: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    private let CellIdentifier = "ArtistNameCell"
    var artist :[Artist] = []
    var categeory = [Category]()
    var cats = [String]()
    var products = [Product]()
    
    var onClickClose: ((_ artist: Artist)->())?
    var onClickCat: ((_ cat: Category)->())?
    var onClickProduct: ((_ cat: Product)->())?
    
    var disposeBag = DisposeBag()
    var ChatVM = ChatViewModel()
    var showArtist = false
    var showProductCat = false
    var showProduct = false
    var showProject = false

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.mainTableView.register(UINib(nibName: self.CellIdentifier, bundle: nil), forCellReuseIdentifier: self.CellIdentifier)
        searchTF.addTarget(self, action: #selector(ArtistNameVC.textFieldDidChange(_:)), for: .editingChanged)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ChatVM.showIndicator()
        if showArtist{
             self.getAllArtist(section : "artists",search: "" ,pageNum :1)
        }else if showProductCat{
            getCategory2()
        }else if showProduct{
            getProduct()
        }else if showProject{
            self.ChatVM.dismissIndicator()
        }else{
            getCategory()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if showArtist{
        self.getAllArtist(section : "artists",search: textField.text ?? "" ,pageNum :1)
        }
    }
    
}
extension ArtistNameVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showArtist{
             return artist.count
        }else if showProduct{
            return products.count
        }else{
            return cats.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as! ArtistNameCell
        if showArtist {
           cell.NameLbl.text = self.artist[indexPath.row].name ?? ""
        }else if showProduct{
           cell.NameLbl.text = self.products[indexPath.row].title ?? ""
        }else {
          cell.NameLbl.text = self.cats[indexPath.row]
        }
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if showArtist {
        let item = self.artist[indexPath.row]
        self.onClickClose?(item)
        }else if showProduct{
        let item = self.products[indexPath.row]
        self.onClickProduct?(item)
        }else{
            let item = self.categeory[indexPath.row]
            self.onClickCat?(item)
         }
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ArtistNameVC {
func getAllArtist(section : String,search:String,pageNum :Int) {
    ChatVM.getSearchArtist(section : section,search:search,pageNum :pageNum).subscribe(onNext: { (dataModel) in
       if dataModel.success ?? false {
        self.ChatVM.dismissIndicator()
        self.artist = dataModel.data ?? []
        self.mainTableView.reloadData()
       }
   }, onError: { (error) in
    self.ChatVM.dismissIndicator()
   }).disposed(by: disposeBag)
  }

    func getCategory() {
        ChatVM.getCategories().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
               self.ChatVM.dismissIndicator()
               self.categeory = dataModel.data ?? []
               for cat in self.categeory{
              self.cats.append(cat.name ?? "")
               }
            self.mainTableView.reloadData()
           }
       }, onError: { (error) in
           self.ChatVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }

    func getCategory2() {
        ChatVM.getProductCategories().subscribe(onNext: { (dataModel) in
            if dataModel.success ?? false {
                self.ChatVM.dismissIndicator()
                self.categeory = dataModel.data ?? []
                for cat in self.categeory{
                    self.cats.append(cat.name ?? "")
                }
             self.mainTableView.reloadData()
            }
        }, onError: { (error) in
            self.ChatVM.dismissIndicator()
          }).disposed(by: disposeBag)
     }
    
    func getProduct(){
        ChatVM.getArtistProduct().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
            self.ChatVM.dismissIndicator()
            self.products = dataModel.data ?? []
            self.mainTableView.reloadData()
           }
       }, onError: { (error) in
           self.ChatVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}
