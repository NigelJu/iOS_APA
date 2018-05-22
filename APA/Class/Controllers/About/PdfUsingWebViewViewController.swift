//
//  PdfUsingWebViewViewController.swift
//  APA
//
//  Created by Nigel on 2018/5/21.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

class PdfUsingWebViewViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadIndicatorView: UIActivityIndicatorView!
    
    var fileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: ".pdf"),
            let pdfUrl = URL(string: path) else { return }
        let request = URLRequest(url: pdfUrl)
        webView.loadRequest(request)
    }
}

// MARK:- UIWebViewDelegate
extension PdfUsingWebViewViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadIndicatorView.stopAnimating()
    }
}
