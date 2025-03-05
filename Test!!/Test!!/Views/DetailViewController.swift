//
//  DetailViewController.swift
//  Test!!
//
//  Created by Bharat Shilavat on 05/03/25.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel : DetailViewModel = DetailViewModel()
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailWebView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let urlString = urlString {
            loadWebPage(withUrlStr: urlString)
        } else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func loadWebPage(withUrlStr: String) {
        guard let url = URL(string: withUrlStr) else {
            showErrorAlert(message: "Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        detailWebView.load(request)
    }
}

//MARK: - WKNavigationDelegate
extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.readyState") { (result, error) in
            if let readyState = result as? String, readyState == "complete" {
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        showErrorAlert(message: "Failed to load the page. Please try again.")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        showErrorAlert(message: "Network error. Please check your connection.")
    }

    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
