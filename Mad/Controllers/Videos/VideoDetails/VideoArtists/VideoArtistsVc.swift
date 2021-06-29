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
            
        }
        cell.showShimmer = showShimmer
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    
}
