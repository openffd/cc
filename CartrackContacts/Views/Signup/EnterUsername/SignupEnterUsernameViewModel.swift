//
//  SignupViewModel.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/11/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import RxSwift

final class SignupEnterUsernameViewModel: ViewModel {
    let usernameMinimumCharacterCount = 3
    
    struct Input {
        let username: AnyObserver<String>
        let signupAction: AnyObserver<Void>
    }
    
    struct Output {
        let signupResult: Observable<User>
        let signupError: Observable<Error>
    }
    
    enum UsernameValidity {
        case valid, invalid
    }
    
    enum UsernameErrorVisibility {
        case shouldShow, shouldHide
    }
    
    init() {
        
    }
    
    func shouldShowError(for username: String) -> UsernameErrorVisibility {
        if username.count > 0 && username.count < usernameMinimumCharacterCount {
            return .shouldShow
        } else {
            return .shouldHide
        }
    }
    
    func validateUsername(_ username: String) -> UsernameValidity {
        guard username.count >= usernameMinimumCharacterCount else {
            return .invalid
        }
        return .valid
    }
}
