//
//  AboutBlogVc.swift
//  Mad
//
//  Created by MAC on 17/06/2022.
//

import UIKit
import WebKit


class AboutBlogVc: UIViewController,WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    var parentVC : BlogDetailsVc?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.isOpaque = false
        webView.navigationDelegate = self
        
    }



}
