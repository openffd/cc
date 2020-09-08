//
//  LoginViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/8/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private var label: UILabel! {
        didSet {
            label.text = "Enter your username:"
            label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 26)
            label.textColor = .black
        }
    }
    @IBOutlet private var textField: UITextField! {
        didSet {
            textField.placeholder = "Username"
            textField.borderStyle = .none
            textField.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        }
    }
    @IBOutlet private var borderView: UIView! {
        didSet {
            borderView.backgroundColor = .black
            borderView.alpha = 0.2
        }
    }
    
    private var nextButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
