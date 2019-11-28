//
//  Extention.swift
//  FirebaseIntegrationDemo
//
//  Created by Dheeraj Arora on 19/11/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import Foundation
import  UIKit

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
