//
//  NewsVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 25/11/23.
//

import UIKit
import WebKit

class NewsVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = SetLanguage.setLang(type: .news)
        navigationController?.navigationBar.prefersLargeTitles = false
        Loader.start()
        
        self.webView.scrollView.subviews.forEach { $0.isUserInteractionEnabled = false }
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        guard let url = URL(string: "https://bronla.uz/blog/1") else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        backView = webView
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Loader.stop()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
}
