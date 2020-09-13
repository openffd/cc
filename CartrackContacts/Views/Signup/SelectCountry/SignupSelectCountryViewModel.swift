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
        let username: BehaviorSubject<String>
        let password: BehaviorSubject<String>
        let country: AnyObserver<String>
        let signupAction: AnyObserver<Void>
    }
    
    struct Output {
        let signupResult: Observable<User>
        let signupError: Observable<Error>
    }
    
    let input: Input
    let output: Output
    
    private var signupFormObservable: Observable<SignupForm> {
        Observable.combineLatest(
            input.username.asObservable(),
            input.password.asObservable(),
            countrySubject.asObservable()) { username, password, country in
            return SignupForm(username: username, password: password, country: country)
        }
    }
    
    private let countrySubject = PublishSubject<String>()
    private let signupActionSubject = PublishSubject<Void>()
    private let signupResultSubject = PublishSubject<User>()
    private let signupErrorSubject = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    init(usernameSubject: BehaviorSubject<String>, passwordSubject: BehaviorSubject<String>) {
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
        
        signupActionSubject
            .withLatestFrom(signupFormObservable)
            .flatMapLatest {
                self.signupService.signup(with: $0).materialize()
            }.debug()
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let user):
                    self?.signupResultSubject.onNext(user)
                case .error(let error):
                    self?.signupErrorSubject.onNext(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
