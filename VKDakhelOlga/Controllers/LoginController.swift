//
//  LoginController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 31/03/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
  
    // MARK: - Outlets
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (#function)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapGR = UITapGestureRecognizer( target: self, action: #selector(hideKeyBoard))
        scrollView.addGestureRecognizer(tapGR)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print (#function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print (#function)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //MARK: - Actions
    
    @IBAction func loginButtonPress(_ sender: Any) {

        }
    //MARK: Private API
    @objc private func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo as NSDictionary?
        let keyboardSize = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentsInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = contentsInsets
        scrollView.scrollIndicatorInsets = contentsInsets
    }
    
    @objc private func keyboardWasHidden(notification: Notification) {
        let contentsInsets = UIEdgeInsets.zero
        
        scrollView.contentInset = contentsInsets
        scrollView.scrollIndicatorInsets = contentsInsets
    }
    @objc private func hideKeyBoard() {
        scrollView.endEditing(true)
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "Show Main Screen"
            else {
                return true
        }
                if usernameInput.text == "",
                   passwordInput.text == "" {
                   return true
                } else {
                    showLoginError()
                    return false
                    }
    }
    private func showLoginError() {
        let loginAlert = UIAlertController(title: "Error", message: "Login/password is incorrect", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.passwordInput.text = ""
        }
        loginAlert.addAction(action)
        present(loginAlert, animated: true)
    }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


