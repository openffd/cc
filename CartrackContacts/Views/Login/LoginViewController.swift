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

class LoginViewController: UIViewController, ViewModelDependent {
    typealias AssociatedViewModel = LoginViewModel
    
    var viewModel: LoginViewModel!
    
    static func instantiate(with viewModel: LoginViewModel) -> LoginViewController {
        let storyboard = UIStoryboard.login
        guard let viewController = storyboard.instantiateInitialViewController() as? LoginViewController else {
            fatalError()
        }
        viewController.viewModel = viewModel
        return viewController
    }
    
    private let disposeBag = DisposeBag()
    
    private var passwordVisibilityButton: UIButton!
    
    @IBOutlet private var logoLabel: UILabel! {
        didSet {
            logoLabel.text = "🄲🄲"
            logoLabel.backgroundColor = .systemOrange
            logoLabel.textColor = .black
            logoLabel.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 60)
        }
    }
    @IBOutlet private var loginLabel: UILabel! {
        didSet {
            loginLabel.text = "Login"
            loginLabel.backgroundColor = .clear
            loginLabel.textColor = .black
            loginLabel.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)
        }
    }
    @IBOutlet private var usernameTextField: UITextField! {
        didSet {
            usernameTextField.placeholder = "username"
            usernameTextField.borderStyle = .none
            usernameTextField.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            usernameTextField.tintColor = .black
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
    @IBOutlet private var loginButton: UIButton! {
        didSet {
            loginButton.backgroundColor = .black
            loginButton.setTitle("LOGIN", for: .normal)
            loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
            loginButton.tintColor = .white
            loginButton.setTitleColor(.white, for: .disabled)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hideNavigationBar()
        
        setupPasswordVisibilityButton()
        
        usernameTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { self.borderView.alpha = 1.0 })
            .disposed(by: disposeBag)
        usernameTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { self.borderView.alpha = 0.2 })
            .disposed(by: disposeBag)
        
        usernameTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: {
                self.usernameTextField.resignFirstResponder()
                self.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { self.passwordBorderView.alpha = 1.0 })
            .disposed(by: disposeBag)
        passwordTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { self.passwordBorderView.alpha = 0.2 })
            .disposed(by: disposeBag)
        
        passwordVisibilityButton.rx.tap
            .subscribe(onNext: self.togglePasswordVisibility)
            .disposed(by: disposeBag)
        
        let usernameText = usernameTextField.rx.text
            .orEmpty
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .share(replay: 1)
        
        let passwordText = passwordTextField.rx.text
            .orEmpty
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .share(replay: 1)
            
        usernameText.subscribe(viewModel.input.username).disposed(by: disposeBag)
        passwordText.subscribe(viewModel.input.password).disposed(by: disposeBag)
        
        let usernameValidity = usernameText.map(viewModel.validate).share(replay: 1)
        let passwordValidity = passwordText.map(viewModel.validate).share(replay: 1)
        let credentialValidity = Observable
            .combineLatest(usernameValidity, passwordValidity) { $0 && $1 }
            .share(replay: 1)
            
        credentialValidity
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        credentialValidity
            .map { $0 ? 1.0 : 0.6 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .subscribe(viewModel.input.loginAction)
            .disposed(by: disposeBag)
        
        viewModel.output.loginResult
            .subscribe(onNext: { user in
                self.presentAlert(for: "Login Successful!")
            })
            .disposed(by: disposeBag)
        
        viewModel.output.loginError
            .subscribe(onNext: { [unowned self] error in
                self.presentAlert(for: error)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6) {
            self.usernameTextField.becomeFirstResponder()
        }
    }
    
    private func setupPasswordVisibilityButton() {
        passwordVisibilityButton = UIButton(type: .custom)
        passwordVisibilityButton.setImage(.passwordHidden, for: .normal)
        passwordVisibilityButton.frame = CGRect(x: .zero, y: .zero, width: 25, height: 25)
        passwordTextField.rightView = passwordVisibilityButton
        passwordTextField.rightViewMode = .always
    }
    
    private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
        let image: UIImage = passwordTextField.isSecureTextEntry ? .passwordHidden : .passwordVisible
        passwordVisibilityButton.setImage(image, for: .normal)
    }
}
