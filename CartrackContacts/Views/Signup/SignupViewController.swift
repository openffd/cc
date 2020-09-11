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

final class SignupViewController: UIViewController, ViewModelDependent {
    typealias AssociatedViewModel = SignupViewModel
    
    var viewModel: SignupViewModel!
    
    static func instantiate(with viewModel: SignupViewModel) -> SignupViewController {
        let storyboard = UIStoryboard.signup
        guard let viewController = storyboard.instantiateInitialViewController() as? SignupViewController else {
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
            usernameErrorLabel.text = "Your username should be at least 4 characters."
        }
    }
    
    private var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create a 🄲🄲 account"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        setupNextButton()
        
        let usernameTextFieldObservable = usernameTextField.rx.text.orEmpty.share(replay: 1)
        
        usernameTextFieldObservable
            .map(viewModel.shouldShowError)
            .distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { isValid in
                self.usernameErrorLabel.isHidden = !isValid
            })
            .disposed(by: disposeBag)
        
        usernameTextFieldObservable
            .map(viewModel.validateUsername)
            .distinctUntilChanged()
            .subscribe(onNext: { isValid in
                self.nextButton.isEnabled = isValid
                self.nextButton.alpha = isValid ? 1.0 : 0.6
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: {
                self.usernameTextField.resignFirstResponder()
                self.showCreatePassword()
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
        let viewController = SignupCreatePasswordViewController.instantiate(with: viewModel)
        show(viewController, sender: nil)
    }
}
