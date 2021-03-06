//
//  SignupViewModel.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/11/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import RxSwift

final class SignupEnterUsernameViewModel: ViewModel, SignupServiceDependent {
    var signupService: SignupService = SignupManager()
    
    let usernameMinimumCharacterCount = 3
    
    struct Input {
        let username: AnyObserver<String>
        let checkAvailabilityAction: AnyObserver<Void>
    }
    
    struct Output {
        let usernameAvailability: Observable<UsernameAvailability>
    }
    
    enum UsernameValidity: Equatable {
        case valid
        case invalid(message: String)
    }
    
    enum UsernameErrorVisibility: Equatable {
        case shouldShow(message: String)
        case shouldHide
    }
    
    let input: Input
    let output: Output

    fileprivate let usernameSubject = BehaviorSubject<String>(value: "")
    private let checkAvailabilityActionSubject = PublishSubject<Void>()
    private let usernameAvailabilitySubject = PublishSubject<UsernameAvailability>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        input = Input(
            username: usernameSubject.asObserver(),
            checkAvailabilityAction: checkAvailabilityActionSubject.asObserver()
        )
        output = Output(
            usernameAvailability: usernameAvailabilitySubject.asObserver()
        )
        checkAvailabilityActionSubject
            .withLatestFrom(usernameSubject.asObservable())
            .flatMapLatest { self.signupService.checkAvailability(username: $0).materialize() }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let userAvailability):
                    self?.usernameAvailabilitySubject.onNext(userAvailability)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func shouldShowError(for username: String) -> UsernameErrorVisibility {
        if username.containsWhitespace {
            // TODO: This is not so DRY
            return .shouldShow(message: "Your username contains invalid characters.")
        }
        
        if username.count > 0 && username.count < usernameMinimumCharacterCount {
            return .shouldShow(message: "Your username should be at least \(usernameMinimumCharacterCount) characters.")
        } else {
            return .shouldHide
        }
    }
    
    func validateUsername(_ username: String) -> UsernameValidity {
        guard !username.containsWhitespace else {
            return .invalid(message: "Your username contains invalid characters.")
        }
        guard username.count >= usernameMinimumCharacterCount else {
            return .invalid(message: "Your username should be at least \(usernameMinimumCharacterCount) characters.")
        }
        return .valid
    }
}

extension SignupEnterUsernameViewModel {
    func instantiateCreatePasswordViewModel() -> SignupCreatePasswordViewModel {
        return SignupCreatePasswordViewModel(usernameSubject: usernameSubject)
    }
}
