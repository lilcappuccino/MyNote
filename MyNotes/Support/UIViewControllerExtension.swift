//
//  UIViewControllerExtension.swift
//  MyNotes
//
//  Created by dewill on 31/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit

extension UIViewController {

        func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
    }
        

}
