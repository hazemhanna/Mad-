//
//  ImageModel.swift
//  Mad
//
//  Created by MAC on 15/04/2021.
//

import UIKit

class Model: NSObject {
    
    var images : [UIImage] = []
    
    func buildDataSource(){
        images = (1...7).map { UIImage(named: "image\($0)")! }
    }
    
}
