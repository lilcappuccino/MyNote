//
//  AuthViewController.swift
//  GitRequest
//
//  Created by dewill on 03/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit
import WebKit


protocol AuthViewControllerDelegate: class {
    func handleTokenChanged(code: String)
}


class AuthViewController: UIViewController , WKUIDelegate{
    let TAG = "AuthViewController"
    weak var delegate: AuthViewControllerDelegate?
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
         guard let request = NetworkUtils.getCode() else { return }
        webView.load(request)
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
    

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == scheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                delegate?.handleTokenChanged(code: code)
                CustomLog.info(tag: TAG, message: "code = \(code)")
            }
            dismiss(animated: true, completion: nil)
        }
        defer { decisionHandler(.allow) }
    }
}

private let scheme = "controller"

//
//  ViewController.swift
//  GitRequest
//
//  Created by dewill on 03/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//
