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
            textField.tintColor = .black
        }
    }
    @IBOutlet private var borderView: UIView! {
        didSet {
            borderView.backgroundColor = .black
            borderView.alpha = 0.2
        }
    }
    @IBOutlet private var instructionLabel: UILabel! {
        didSet {
            instructionLabel.text = "Username should be at least 4 characters."
            instructionLabel.font = UIFont(name: "HelveticaNeue", size: 12)
            instructionLabel.textColor = .systemRed
        }
    }
    
    private var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hideNavigationBar()
        
        setupNextButton()
        
        let _ = textField
            .rx.text
            .orEmpty
            .throttle(DispatchTimeInterval.microseconds(100), scheduler: MainScheduler.instance)
            .map { $0.count >= 4 }
            .share(replay: 1)
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let _ = textField
            .rx.text.orEmpty
            .throttle(DispatchTimeInterval.microseconds(100), scheduler: MainScheduler.instance)
            .map { $0.count == 0 || $0.count >= 4 }
            .share(replay: 1)
            .bind(to: instructionLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupNextButton() {
        nextButton = {
            let button = UIButton(type: .system)
            let buttonHeight: CGFloat = 60.0, buttonWidth: CGFloat = 60.0
            button.frame = CGRect(x: UIScreen.main.bounds.width - buttonWidth - 16.0, y: .zero, width: buttonWidth, height: buttonHeight)
            button.setImage(UIImage(named: "ArrowRight"), for: .normal)
            button.backgroundColor = .black
            button.tintColor = .white
            button.layer.cornerRadius = buttonHeight / 2
            button.addTarget(self, action: #selector(showPassword(_:)), for: .touchUpInside)
            button.isEnabled = false
            return button
        }()
        
        let accessoryView = UIView(frame: CGRect(x: .zero, y: .zero, width: nextButton.frame.width + 10, height: nextButton.frame.height + 10))
        accessoryView.addSubview(nextButton)
        textField.inputAccessoryView = accessoryView
    }
    
    @objc private func showPassword(_ sender: Any) {
        
    }
}
