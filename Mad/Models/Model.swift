//
//  Model.swift
//  Mad
//
//  Created by MAC on 06/04/2021.
//

import Foundation
import UIKit

class Model: NSObject {
    
    var images : [UIImage] = []
    
    // Assemble an array of images to use for sample content for the collectionView
    func buildDataSource(){
        images = (1...7).map { UIImage(named: "image\($0)")! }
    }
    
}
