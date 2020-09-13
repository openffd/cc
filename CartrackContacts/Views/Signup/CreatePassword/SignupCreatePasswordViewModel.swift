//
//  SignupCreatePasswordViewModel.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/12/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import RxSwift

final class SignupCreatePasswordViewModel: ViewModel {
    
    struct Input {
        let usernameSubject: PublishSubject<String>
        let password: AnyObserver<String>
    }
    
    struct Output {}
    
    enum PasswordValidity {
        case valid, invalid
    }
    
    enum PasswordErrorVisibility {
        case shouldShow, shouldHide
    }
    
    let passwordMinimumCharacterCount = 3
    
    let input: Input
    let output: Output
    
    fileprivate let passwordSubject = PublishSubject<String>()
    let proceedAction = PublishSubject<Void>()
    
    init(usernameSubject: PublishSubject<String>) {
        input = Input(usernameSubject: usernameSubject, password: passwordSubject.asObserver())
        output = Output()
    }
    
    func shouldShowError(for password: String) -> PasswordErrorVisibility {
        if password.count > 0 && password.count < passwordMinimumCharacterCount {
            return .shouldShow
        } else {
            return .shouldHide
        }
    }
        
    func validatePassword(_ password: String) -> PasswordValidity {
        guard password.count >= passwordMinimumCharacterCount else {
            return .invalid
        }
        return .valid
    }
}

extension SignupCreatePasswordViewModel {
    func instantiateSelectCountryViewModel() -> SignupSelectCountryViewModel {
        SignupSelectCountryViewModel(usernameSubject: input.usernameSubject, passwordSubject: passwordSubject)
    }
}
