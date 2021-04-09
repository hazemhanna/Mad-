//
//  UIViewController+Extention.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//

import Foundation
import UIKit
import Toast_Swift
import KSToastView

extension UIViewController {
    
    func showMessage(text: String, duration: TimeInterval = 3) {
        KSToastView.ks_showToast(text, duration: duration)
    }

}
