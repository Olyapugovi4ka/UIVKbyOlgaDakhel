//
//  UIViewController+Ext.swift
//  VKDakhelOlga
//
//  Created by MacBook on 31/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

extension UIViewController {
func show(_ error: Error) {
let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
let action = UIAlertAction(title: "Ok", style: .default)
alertVC.addAction(action)
present(alertVC, animated: true)
    }
    
}
