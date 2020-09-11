//
//  LandingViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

class LandingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet private var appNameLabel: UILabel! {
        didSet {
            appNameLabel.text = "🄲🄲"
            appNameLabel.textColor = .black
            appNameLabel.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 80)
        }
    }
    @IBOutlet private var animationContainerView: UIView! {
        didSet {
            animationContainerView.backgroundColor = .clear
        }
    }
    @IBOutlet private var loginButton: UIButton! {
        didSet {
            loginButton.tintColor = .white
            loginButton.setTitle("LOGIN", for: .normal)
            loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        }
    }
    @IBOutlet private var signupButton: UIButton! {
        didSet {
            signupButton.backgroundColor = .black
            signupButton.tintColor = .white
            signupButton.setTitle("SIGN UP", for: .normal)
            signupButton.titleLabel?.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        }
    }
    
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        
        loginButton.rx.tap
            .subscribe(onNext: { self.showLogin() })
            .disposed(by: disposeBag)
        
        signupButton.rx.tap
            .subscribe(onNext: { self.showSignup() })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimationView()
    }
    
    private func setupAnimationView() {
        animationView = .init(name: "Sedan")
        animationView?.frame = animationContainerView.bounds
        animationView?.backgroundColor = .clear
        animationView?.contentMode = .scaleAspectFill
        animationView?.loopMode = .loop
        animationContainerView.addSubview(animationView!)
        animationView?.play()
    }
    
    private func showLogin() {
        let viewController = LoginViewController.instantiate(with: LoginViewModel())
        show(viewController, sender: nil)
    }
    
    private func showSignup() {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 32)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        let viewController = SignupViewController.instantiate(with: SignupViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.hideNavigationBar()
        navigationController.navigationBar.barTintColor = .systemOrange
        show(navigationController, sender: nil)
    }
}
