//
//  MainViewController.swift
//  SimpleWebBrowser
//
//  Created by SindhuS on 10/11/21.
//

import UIKit
import WebKit

class MainViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    //MARK: - Parameters
    var requestUrl = "https://timesofindia.indiatimes.com"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        self.setupData()
    }
    
    //MARK: - Methods
    func setupViews() {
        
        self.searchField.delegate = self
        self.webView.navigationDelegate = self
        self.backButton.isEnabled = false
        self.forwardButton.isEnabled = false
    }
    
    func setupData() {
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.webView.load(requestUrl)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "loading" {
            
            self.backButton.isEnabled = self.webView.canGoBack
            self.forwardButton.isEnabled = self.webView.canGoForward
        } else if keyPath == "estimatedProgress" {
            
            self.progressBar.isHidden = self.webView.estimatedProgress == 1
            self.progressBar.setProgress(Float(self.webView.estimatedProgress), animated: true)
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func back(_ sender: Any) {
        
        self.webView.goBack()
    }
    
    @IBAction func forward(_ sender: Any) {
        
        self.webView.goForward()
    }
    
    @IBAction func reload(_ sender: Any) {
        
        self.webView.reload()
    }
}

extension MainViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.searchField.text = webView.url?.absoluteString
        self.progressBar.setProgress(0.0, animated: false)
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.searchField.resignFirstResponder()
        if let str =  textField.text {
            
            self.requestUrl = "https://"+str
            self.webView.load(self.requestUrl)
        }
        return false
    }
}

extension WKWebView {
    
    func load(_ urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
