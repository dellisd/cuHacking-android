//
//  PrivacyPolicyViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-12-03.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    let webView = WKWebView()
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        if let url = URL(string: "https://docs.google.com/document/d/1u4FqlEz4D6BiZ9x0sPiHfZFCKRSzACiXPQFfWrRQPF8/edit?usp=sharing") {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            navigationController?.popViewController(animated: false)
        }
    }
}
