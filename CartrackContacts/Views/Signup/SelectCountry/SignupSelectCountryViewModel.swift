//
//  SignupSelectCountryViewModel.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/12/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import RxSwift

final class SignupSelectCountryViewModel: ViewModel, SignupServiceDependent {
    var signupService: SignupService = SignupManager()
    
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
    
    let input: Input
    let output: Output
    
    private let countrySubject = PublishSubject<String>()
    private let signupActionSubject = PublishSubject<Void>()
    private let signupResultSubject = PublishSubject<User>()
    private let signupErrorSubject = PublishSubject<Error>()
    
    init(username: AnyObserver<String>, password: AnyObserver<String>) {
        input = Input(
            username: username,
            password: password,
            country: countrySubject.asObserver(),
            signupAction: signupActionSubject.asObserver()
        )
        output = Output(
            signupResult: signupResultSubject.asObserver(),
            signupError: signupErrorSubject.asObserver()
        )
    }
}
