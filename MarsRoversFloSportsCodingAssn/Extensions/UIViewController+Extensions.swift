//
//  UIViewController+Extensions.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/4/19.
//  Copyright © 2019 test. All rights reserved.
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
