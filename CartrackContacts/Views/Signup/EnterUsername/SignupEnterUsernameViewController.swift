//
//  SignupViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/8/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignupEnterUsernameViewController: UIViewController, ViewModelDependent {
    typealias AssociatedViewModel = SignupEnterUsernameViewModel
    
    var viewModel: SignupEnterUsernameViewModel!
    
    static func instantiate(with viewModel: SignupEnterUsernameViewModel) -> SignupEnterUsernameViewController {
        let storyboard = UIStoryboard.signup
        guard let viewController = storyboard.instantiateInitialViewController() as? SignupEnterUsernameViewController else {
            fatalError()
        }
        viewController.viewModel = viewModel
        return viewController
    }
    
    private let disposeBag = DisposeBag()

    @IBOutlet private var usernameQuestionLabel: UILabel! {
        didSet {
            usernameQuestionLabel.text = "Your username:"
            usernameQuestionLabel.font = .helveticaNeueCondensedBold(size: 32)
            usernameQuestionLabel.adjustsFontSizeToFitWidth = true
            usernameQuestionLabel.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet private var usernameTextField: UITextField! {
        didSet {
            usernameTextField.borderStyle = .none
            usernameTextField.font = .helveticaNeueBold(size: 20)
            usernameTextField.placeholder = "username"
        }
    }
    
    @IBOutlet private var usernameBorderView: UIView! {
        didSet {
            usernameBorderView.backgroundColor = .black
        }
    }
    
    @IBOutlet private var usernameErrorLabel: UILabel! {
        didSet {
            usernameErrorLabel.isHidden = true
            usernameErrorLabel.textColor = .systemGreen
            usernameErrorLabel.font = .helveticaNeue(size: 12)
            usernameErrorLabel.text = "Your username should be at least \(viewModel.usernameMinimumCharacterCount) characters."
        }
    }
    
    private var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create a 🄲🄲 account"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        setupNextButton()
        
        let usernameTextFieldObservable = usernameTextField.rx.text.orEmpty.share(replay: 1)
        usernameTextFieldObservable.subscribe(viewModel.input.username).disposed(by: disposeBag)
        
        usernameTextFieldObservable
            .map(viewModel.shouldShowError)
            .distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .shouldHide:
                    self.usernameErrorLabel.isHidden = true
                case .shouldShow:
                    self.usernameErrorLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        usernameTextFieldObservable
            .map(viewModel.validateUsername)
            .distinctUntilChanged()
            .subscribe(onNext: {
                switch $0 {
                case .invalid:
                    self.nextButton.isEnabled = false
                case .valid:
                    self.nextButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        let nextButtonTap = nextButton.rx.tap.share(replay: 1)
            
        nextButtonTap
            .subscribe(onNext: { self.usernameTextField.resignFirstResponder() })
            .disposed(by: disposeBag)
        
        nextButtonTap
            .subscribe(viewModel.input.checkAvailabilityAction)
            .disposed(by: disposeBag)
        
        viewModel.output.usernameAvailability
            .subscribe(onNext: { [weak self] usernameAvailability in
                guard usernameAvailability == .available else {
                    self?.presentAlert(for: usernameAvailability.message)
                    return
                }
                self?.showCreatePassword()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        UIView.animate(withDuration: 0.6, animations: {
            self.usernameTextField.becomeFirstResponder()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.usernameTextField.resignFirstResponder()
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
        usernameTextField.inputAccessoryView = accessoryView
    }
    
    private func showCreatePassword() {
        let createPasswordViewModel = self.viewModel.instantiateCreatePasswordViewModel()
        let viewController = SignupCreatePasswordViewController.instantiate(with: createPasswordViewModel)
        show(viewController, sender: nil)
    }
}
