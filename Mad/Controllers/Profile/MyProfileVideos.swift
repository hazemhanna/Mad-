//
//  MyProfileVideos.swift
//  Mad
//
//  Created by MAC on 03/07/2021.
//



import UIKit
import RxSwift
import RxCocoa

class MyProfileVideos : UIViewController {
    
    var artistVM = ArtistViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
}


