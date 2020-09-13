//
//  SignupSelectCountryViewModel.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/12/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import RxSwift

struct SignupForm {
    let username: String
    let password: String
    let country: String
}

final class SignupSelectCountryViewModel: ViewModel, SignupServiceDependent {
    var signupService: SignupService = SignupManager()
    
    struct Input {
        let username: PublishSubject<String>
        let password: PublishSubject<String>
        let country: AnyObserver<String>
        let signupAction: AnyObserver<Void>
    }
    
    struct Output {
        let signupResult: Observable<User>
        let signupError: Observable<Error>
    }
    
    let input: Input
    let output: Output
    
    private var signupForm: Observable<SignupForm> {
        Observable.combineLatest(
            input.username,
            input.password,
            countrySubject.asObservable()) { username, password, country in
            return SignupForm(username: username, password: password, country: country)
        }
    }
    
    private let countrySubject = PublishSubject<String>()
    private let signupActionSubject = PublishSubject<Void>()
    private let signupResultSubject = PublishSubject<User>()
    private let signupErrorSubject = PublishSubject<Error>()
    
    init(usernameSubject: PublishSubject<String>, passwordSubject: PublishSubject<String>) {
        input = Input(
            username: usernameSubject,
            password: passwordSubject,
            country: countrySubject.asObserver(),
            signupAction: signupActionSubject.asObserver()
        )
        output = Output(
            signupResult: signupResultSubject.asObserver(),
            signupError: signupErrorSubject.asObserver()
        )
        
        signupActionSubject.withLatestFrom(self.signupForm)
    }
}
