//
//  LoginViewModel.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/9/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import RxSwift

final class LoginViewModel: ViewModel, LoginServiceDependent, SessionServiceDependent {
    var loginService: LoginService = LoginManager()
    var sessionService: SessionService = SessionManager()
    
    struct Input {
        let username: AnyObserver<String>
        let password: AnyObserver<String>
        let loginAction: AnyObserver<Void>
    }
    
    struct Output {
        let loginResult: Observable<User>
        let loginError: Observable<Error>
    }
    
    let input: Input
    let output: Output
    
    private let usernameSubject     = PublishSubject<String>()
    private let passwordSubject     = PublishSubject<String>()
    private let loginActionSubject  = PublishSubject<Void>()
    private let loginResultSubject  = PublishSubject<User>()
    private let loginErrorSubject   = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    func validate(credentialField: String) -> Bool { !credentialField.isEmpty }
    
    private var validCredentialObservable: Observable<Credential> {
        Observable.combineLatest(
            usernameSubject.asObservable(),
            passwordSubject.asObservable()
        ) { username, password in
            return Credential(username: username, password: password)
        }
    }
    
    init() {
        input = Input(
            username: usernameSubject.asObserver(),
            password: passwordSubject.asObserver(),
            loginAction: loginActionSubject.asObserver()
        )
        output = Output(
            loginResult: loginResultSubject.asObserver(),
            loginError: loginErrorSubject.asObserver()
        )
        loginActionSubject
            .withLatestFrom(validCredentialObservable)
            .flatMapLatest { self.loginService.login(with: $0).materialize() }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let user):
                    self?.loginResultSubject.onNext(user)
                    self?.sessionService.saveSession(Session(user: user))
                case .error(let error):
                    self?.loginErrorSubject.onNext(error)
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
}
