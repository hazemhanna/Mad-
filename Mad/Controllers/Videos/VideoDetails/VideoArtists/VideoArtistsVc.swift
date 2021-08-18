//
//  VideoArtistsVc.swift
//  Mad
//
//  Created by MAC on 19/05/2021.
//

import UIKit

class VideoArtistsVc: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let CellIdentifier = "VideoArtistCell"
    
    var showShimmer: Bool = true
    var parentVC : VideoDetailsVc?
    var artist = [Artist](){
        didSet{
            tableView.reloadData()
            showShimmer = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
}

extension VideoArtistsVc : UITableViewDelegate,UITableViewDataSource{
    
    func setupContentTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.CellIdentifier, bundle: nil), forCellReuseIdentifier: self.CellIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.showShimmer ? 1 : self.artist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier) as! VideoArtistCell
        if !self.showShimmer{
            cell.confic(title : self.artist[indexPath.row].headline ?? "" ,
                        profilPicture: self.artist[indexPath.row].profilPicture ?? "",
                        isFavourite: self.artist[indexPath.row].isFavorite ?? false,
                        art: self.artist[indexPath.row].isFavorite ?? false,
                        music: self.artist[indexPath.row].isFavorite ?? false,
                        design: self.artist[indexPath.row].isFavorite ?? false)
            
            cell.editFavourite = {
                if Helper.getAPIToken() != nil {
                    self.parentVC?.videoVM.showIndicator()
             if self.artist[indexPath.row].isFavorite ?? false{
                self.parentVC?.addToFavourite(artistId:  self.artist[indexPath.row].id ?? 0, Type: false)
                cell.favouriteBtn.backgroundColor = #colorLiteral(red: 0.9282042384, green: 0.2310142517, blue: 0.4267850518, alpha: 1)
                self.tableView.reloadData()
                }else{
                    self.parentVC?.addToFavourite(artistId:  self.artist[indexPath.row].id ?? 0, Type: true)
                    cell.favouriteBtn.backgroundColor = #colorLiteral(red: 0.5764705882, green: 0.6235294118, blue: 0.7137254902, alpha: 1)
                    self.tableView.reloadData()
               }
               }else {
                self.showMessage(text: "please login first")
             }
            }
        }
        cell.showShimmer = showShimmer
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Artist", bundle: nil).instantiateViewController(withIdentifier: "ArtistProfileVc")  as! ArtistProfileVc
            vc.artistId = self.artist[indexPath.row].id ?? 0
            Helper.saveArtistId(id: self.artist[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

