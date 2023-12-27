//
//  OtherAppsVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 27/11/23.
//

import UIKit
import WebKit

class OtherAppsVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupViews()
    }
    
    private func setupViews(){
        Loader.start()
        title = SetLanguage.setLang(type: .otherApps)
        navigationController?.navigationBar.tintColor = AppColors.mainColor
        
        guard let url = URL(string: "https://apps.apple.com/uz/developer/uchqun-tulavov/id1603826963") else { return }
        let urlRequest = URLRequest(url: url)
        
        webView.load(urlRequest)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        backView = webView
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Loader.stop()
        }
    }
    
}
