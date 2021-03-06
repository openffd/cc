//
//  SignupSelectCountryViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/12/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CountryPickerView

final class SignupSelectCountryViewController: UIViewController, ViewModelDependent {
    typealias AssociatedViewModel = SignupSelectCountryViewModel
    
    var viewModel: SignupSelectCountryViewModel!
    
    static func instantiate(with viewModel: SignupSelectCountryViewModel) -> SignupSelectCountryViewController {
        let storyboard = UIStoryboard.signup
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "SignupSelectCountryViewController") as? SignupSelectCountryViewController else {
            fatalError()
        }
        viewController.viewModel = viewModel
        return viewController
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private var selectCountryLabel: UILabel! {
        didSet {
            selectCountryLabel.text = "Select your country:"
            selectCountryLabel.font = .helveticaNeueCondensedBold(size: 32)
            selectCountryLabel.adjustsFontSizeToFitWidth = true
            selectCountryLabel.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet private var countryPickerContainerView: UIView! {
        didSet {
            countryPickerContainerView.layer.borderColor = UIColor.systemOrange.cgColor
            countryPickerContainerView.layer.borderWidth = 2
            countryPickerContainerView.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet private var countryPickerView: CountryPickerView! {
        didSet {
            countryPickerView.showCountryCodeInView = false
            countryPickerView.showCountryNameInView = true
            countryPickerView.showPhoneCodeInView = false
        }
    }
    
    @IBOutlet private var nextButton: UIButton! {
        didSet {
            nextButton.backgroundColor = .black
            nextButton.tintColor = .white
            nextButton.setTitle("SUBMIT", for: .normal)
            nextButton.titleLabel?.font = .helveticaNeueCondensedBold(size: 20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create a 🄲🄲 account"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        viewModel.input.country.onNext(countryPickerView.selectedCountry.name)
        
        nextButton.rx.tap.subscribe(viewModel.input.signupAction).disposed(by: disposeBag)
        
        viewModel.output.signupResult
            .subscribe(onNext: { user in
                self.showContacts()
            }).disposed(by: disposeBag)
        
        viewModel.output.signupError
            .subscribe(onNext: { error in
                self.presentAlert(for: error)
            }).disposed(by: disposeBag)
    }
    
    private func showContacts() {
        let containerViewController = UIViewController()
        let viewController = UIStoryboard.contacts.instantiateInitialViewController()!
        containerViewController.addChild(viewController)
        containerViewController.view.addSubview(viewController.view)
        viewController.view.frame = viewController.view.frame
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: containerViewController)
        containerViewController.modalPresentationStyle = .fullScreen
        present(containerViewController, animated: true, completion: nil)
    }
}

extension SignupSelectCountryViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        viewModel.input.country.onNext(country.name)
    }
}

extension SignupSelectCountryViewController: CountryPickerViewDataSource {
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        "Select a country"
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        .tableViewHeader
    }
}
