//
//  NewsWebViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/14/23.
//

import UIKit
import WebKit

class NewsWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.layer.cornerRadius = 20
        
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: URL(string: url)!))
    }
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationItem.backBarButtonItem?.title = ""
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navigationController?.navigationBar.tintColor = .white
}

}
