//
//  LandingViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit
import Lottie

class LandingViewController: UIViewController {

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
    
    @IBAction private func login(_ sender: UIButton) {
        performSegue(withIdentifier: .showLogin, sender: nil)
    }
    
    @IBAction private func signup(_ sender: UIButton) {
        performSegue(withIdentifier: .showSignup, sender: nil)
    }
}

typealias SegueIdentifier = String
private extension SegueIdentifier {
    static let showSignup = "ShowSignup"
    static let showLogin = "ShowLogin"
}
