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
    let passwordMinimumCharacterCount = 3
    
    struct Input {
        let password: AnyObserver<String>
        let proceedAction: AnyObserver<Void>
    }
    
    struct Output {
        let passwordError: Observable<Error>
    }
    
    init() {
        
    }
    
    func shouldShowError(for password: String) -> Bool {
        password.count > 0 && password.count < passwordMinimumCharacterCount
    }
    
    func validatePassword(_ password: String) -> Bool {
        password.count >= passwordMinimumCharacterCount
    }
}
