//
//  SignupViewModel.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/11/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import RxSwift

final class SignupViewModel: ViewModel {
    struct Input {
        let username: AnyObserver<String>
        let password: AnyObserver<String>
        let country: AnyObserver<String>
        let signupAction: AnyObserver<Void>
    }
    
    struct Output {
        let signupResult: Observable<User>
        let signupError: Observable<Error>
    }
    
    init() {
        
    }
    
    func shouldShowError(for username: String) -> Bool {
        username.count > 0 && username.count < 4
    }
    
    func validateUsername(_ username: String) -> Bool {
        username.count >= 4
    }
}
