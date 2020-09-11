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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
