//
//  LoginViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/8/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet private var textField: UITextField! {
        didSet {
            textField.placeholder = "username"
            textField.borderStyle = .none
            textField.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            textField.tintColor = .black
        }
    }
    @IBOutlet private var borderView: UIView! {
        didSet {
            borderView.backgroundColor = .black
            borderView.alpha = 0.2
        }
    }
    @IBOutlet private var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.placeholder = "password"
            passwordTextField.borderStyle = .none
            passwordTextField.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            passwordTextField.tintColor = .black
        }
    }
    @IBOutlet private var passwordBorderView: UIView! {
        didSet {
            passwordBorderView.backgroundColor = .black
            passwordBorderView.alpha = 0.2
        }
    }
    
    private var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hideNavigationBar()
        
        let _ = textField.rx.controlEvent(.editingDidBegin).share(replay: 1).map { 1.0 }.bind(to: borderView.rx.alpha).disposed(by: disposeBag)
        let _ = passwordTextField.rx.controlEvent(.editingDidBegin).share(replay: 1).map { 1.0 }.bind(to: passwordBorderView.rx.alpha).disposed(by: disposeBag)
        let _ = textField.rx.controlEvent(.editingDidEnd).share(replay: 1).map { 0.2 }.bind(to: borderView.rx.alpha).disposed(by: disposeBag)
        let _ = passwordTextField.rx.controlEvent(.editingDidEnd).share(replay: 1).map { 0.2 }.bind(to: passwordBorderView.rx.alpha).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6) {
            self.textField.becomeFirstResponder()
        }
    }
    
    @objc private func showPassword(_ sender: Any) {
        
    }
}
