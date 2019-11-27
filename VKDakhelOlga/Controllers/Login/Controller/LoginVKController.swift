//
//  LoginVKController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 21/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import WebKit

class LoginVKController: UIViewController {
    
   // weak var coordinator: MainCoordinator?

    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
        URLQueryItem(name: "client_id", value: "6991747"),
        URLQueryItem(name: "scope", value: "offline,friends,photos,groups,wall,email,video,messages"),
        URLQueryItem(name: "display", value: "mobile"),
        URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
        URLQueryItem(name: "response_type", value: "token"),
        URLQueryItem(name: "v", value: "5.95")
        
]
        let request = URLRequest(url: components.url!)
        webView.load(request)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       // let identifier = "ShowMainScreen"

    
    }
    
}
extension LoginVKController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {decisionHandler(.allow); return}
        
        //MARK: - Parsing response dictionary
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=")}
            .reduce([String:String]()) {result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
                
        }
        
        //MARK: - Fetching token and userId
        guard let token = params["access_token"],
            let userIdString = params["user_id"],
            let userId = Int(userIdString) else {
                decisionHandler(.allow)
                return
        }
       
        //MARK: Add datas in singletone
        Account.shared.token = token
        Account.shared.userId = userId
        
        performSegue(withIdentifier: "ShowMainScreen", sender: nil)
       // coordinator?.showNews()
        
        decisionHandler(.cancel)
        
    }
    
    
}
