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
    typealias AssociatedViewModel = SignupCreatePasswordViewModel
    
    var viewModel: SignupCreatePasswordViewModel!
    
    static func instantiate(with viewModel: SignupCreatePasswordViewModel) -> SignupCreatePasswordViewController {
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
            passwordErrorLabel.text = "Your password should be at least \(viewModel.passwordMinimumCharacterCount) characters."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create a 🄲🄲 account"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        setupPasswordVisibilityButton()
        
        setupNextButton()
        
        let passwordTextFieldObservable = passwordTextField.rx.text.orEmpty.share(replay: 1)
        passwordTextFieldObservable.subscribe(viewModel.input.password).disposed(by: disposeBag)
        
        passwordTextFieldObservable
            .map(viewModel.shouldShowError)
            .distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .shouldHide:
                    self.passwordErrorLabel.isHidden = true
                case .shouldShow:
                    self.passwordErrorLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        passwordTextFieldObservable
            .map(viewModel.validatePassword(_:))
            .distinctUntilChanged()
            .subscribe(onNext: {
                switch $0 {
                case .invalid:
                    self.nextButton.isEnabled = false
                    self.nextButton.alpha = 0.6
                case .valid:
                    self.nextButton.isEnabled = true
                    self.nextButton.alpha = 1.0
                }
            })
            .disposed(by: disposeBag)
        
        passwordVisibilityButton.rx.tap
            .subscribe(onNext: { self.togglePasswordVisibility() })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { self.showSelectCountry() })
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
    
    private func showSelectCountry() {
        let selectCountryViewModel = viewModel.instantiateSelectCountryViewModel()
        let viewController = SignupSelectCountryViewController.instantiate(with: selectCountryViewModel)
        show(viewController, sender: nil)
    }
}
