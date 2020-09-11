//
//  SignupCreatePasswordViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/11/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignupCreatePasswordViewController: UIViewController, ViewModelDependent {
    typealias AssociatedViewModel = SignupViewModel
    
    var viewModel: SignupViewModel!
    
    static func instantiate(with viewModel: SignupViewModel) -> SignupCreatePasswordViewController {
        let storyboard = UIStoryboard.signup
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "SignupCreatePasswordViewController") as? SignupCreatePasswordViewController else {
            fatalError()
        }
        viewController.viewModel = viewModel
        return viewController
    }
    
    private let disposeBag = DisposeBag()
    
    private var passwordVisibilityButton: UIButton!
    private var nextButton: UIButton!
    
    @IBOutlet private var passwordQuestionLabel: UILabel! {
        didSet {
            passwordQuestionLabel.text = "Create a password:"
            passwordQuestionLabel.font = .helveticaNeueCondensedBold(size: 32)
            passwordQuestionLabel.adjustsFontSizeToFitWidth = true
            passwordQuestionLabel.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet private var passwordTextField: UITextField! {
        didSet {
            passwordTextField.borderStyle = .none
            passwordTextField.font = .helveticaNeueBold(size: 20)
            passwordTextField.placeholder = "password"
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBOutlet private var passwordBorderView: UIView! {
        didSet {
            passwordBorderView.backgroundColor = .black
        }
    }
    
    @IBOutlet private var passwordErrorLabel: UILabel! {
        didSet {
            passwordErrorLabel.isHidden = true
            passwordErrorLabel.textColor = .systemGreen
            passwordErrorLabel.font = .helveticaNeue(size: 12)
            passwordErrorLabel.text = "Your password should be at least 4 characters."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPasswordVisibilityButton()
        
        setupNextButton()
        
        let passwordTextFieldObservable = passwordTextField.rx.text.orEmpty.share(replay: 1)
        
        passwordTextFieldObservable
            .map { $0.count > 0 && $0.count < 4 }
            .distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { isValid in
                self.passwordErrorLabel.isHidden = !isValid
            })
            .disposed(by: disposeBag)
        
        passwordTextFieldObservable
            .map { $0.count >= 4 }
            .distinctUntilChanged()
            .subscribe(onNext: { isValid in
                self.nextButton.isEnabled = isValid
                self.nextButton.alpha = isValid ? 1.0 : 0.6
            })
            .disposed(by: disposeBag)
        
        passwordVisibilityButton.rx.tap
            .subscribe(onNext: { self.togglePasswordVisibility() })
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6) {
            self.passwordTextField.becomeFirstResponder()
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
    
    private func setupNextButton() {
        let height: CGFloat = 64, width: CGFloat = 64
        nextButton = {
            let button = UIButton(type: .custom)
            button.frame = CGRect(
                origin: CGPoint(x: UIScreen.main.bounds.width - width - 20, y: .zero),
                size: CGSize(width: height, height: width)
            )
            button.backgroundColor = .black
            button.tintColor = .white
            button.layer.cornerRadius = height / 2
            button.setImage(UIImage.arrowRight, for: .normal)
            button.isEnabled = false
            return button
        }()
        let accessoryView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: height + 10, height: width + 10)))
        accessoryView.addSubview(nextButton)
        passwordTextField.inputAccessoryView = accessoryView
    }
}
