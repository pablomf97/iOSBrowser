//
//  ViewController.swift
//  Browser
//
//  Created by Pablo Figueroa Martínez on 22/12/20.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    // MARK: - Attributes & views
    
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var favouritesButton: UIButton!
    @IBOutlet var addFavouriteButton: UIButton!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
       
    // MARK: - Overrided funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.delegate = self
        prepareWebView()
        prepareButtons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! FavouritesTableTableViewController).callBack = {
            (url) in self.goTo(url: url)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        urlTextField.placeholder = webView.url?.absoluteString ?? "http://www..."
        spinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }
    
    // MARK: - Buttons
    
    @IBAction func backButton() {
        if webView.canGoBack {
            webView.goBack()
            urlTextField.text = ""
            urlTextField.placeholder = webView.url?.absoluteString
        }
    }
    
    @IBAction func forwardButton() {
        if webView.canGoForward {
            webView.goForward()
            urlTextField.text = ""
            urlTextField.placeholder = webView.url?.absoluteString
        }
    }
    
    @IBAction func reloadButton() {
        webView.reload()
    }
    
    @IBAction func addFavouriteButtonAction() {
        let alert = UIAlertController(title: "Add this page to favourites?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            self.updateFavourites()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func homeButtonAction() {
        goHome()
    }
    
    // MARK: - Browser stuff
    
    func prepareWebView() {
        webView.navigationDelegate = self
        goHome()
        webView.scrollView.maximumZoomScale = 4.0
        webView.scrollView.minimumZoomScale = 1.0
    }
    
    func goHome() {
        goTo(url: "https://google.com")
    }
    
    func goTo(url: String) {
        let parsedUrl = URL(string: url)
        let request = URLRequest(url: parsedUrl!)
        webView.load(request)
        urlTextField.text = ""
        urlTextField.placeholder = url
    }
    
    func prepareButtons() {
        homeButton.setBackgroundImage(UIImage(systemName: "house.fill"), for: .normal)
        favouritesButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        addFavouriteButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    // MARK: - URL Textfield
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let url = textField.text!
        
        if url.starts(with: "https://ww") {
            goTo(url: url)
        } else {
            let alert = UIAlertController.init(title: "Oops!", message: "URL is not valid...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
        return true
    }
    
    // MARK: - Miscellaneous
    
    func updateFavourites() {
        if var favourites = UserDefaults.standard.stringArray(forKey: "favourites") {
            favourites.append(webView.url!.absoluteString)
            UserDefaults.standard.set(favourites, forKey: "favourites")
        } else {
            UserDefaults.standard.set([webView.url!.absoluteString], forKey: "favourites")
        }
    }
    
    @IBAction func changeURLFieldText() {
        urlTextField.text = urlTextField.placeholder!
        urlTextField.becomeFirstResponder()
    }
}

