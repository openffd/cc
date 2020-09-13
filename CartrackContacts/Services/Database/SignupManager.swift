//
//  SignupManager.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/13/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import RxSwift

protocol SignupService {
    func checkAvailability(username: String) -> Observable<UsernameAvailability>
    func signup(username: String, digest: String, country: String) -> Observable<User>
    func signup(with form: SignupForm) -> Observable<User>
}

protocol SignupServiceDependent {
    var signupService: SignupService { get }
}

final class SignupManager: SignupService {
    let userDatabase: SQLite.Database = .shared
    
    func checkAvailability(username: String) -> Observable<UsernameAvailability> {
        Observable.create { observer in
            observer.onNext(self.checkUser(with: username))
            return Disposables.create()
        }
    }
    
    func signup(with form: SignupForm) -> Observable<User> {
        signup(username: form.username, digest: form.password.sha256Digest, country: form.country)
    }
    
    func signup(username: String, digest: String, country: String) -> Observable<User> {
        Observable.create { observer in
            switch self.register(username: username, digest: digest, country: country) {
            case .failure(let error):
                observer.onError(error)
            case .success(let user):
                observer.onNext(user)
            }
            return Disposables.create()
        }
    }
    
    private func register(username: String, digest: String, country: String) -> SignupResult {
        do {
            let user = try userDatabase.insert(username: username, digest: digest, country: country)
            return .success(user: user)
        } catch {
            return .failure(error: .insertFailure)
        }
    }
    
    private func checkUser(with username: String) -> UsernameAvailability {
        userDatabase.checkUser(username: username)
    }
}

enum SignupResult {
    case success(user: User)
    case failure(error: SignupError)
}

enum SignupError: LocalizedError {
    case insertFailure
    
    var errorDescription: String? {
        switch self {
        case .insertFailure:
            return "Unable to signup at this time. Please try again later."
        }
    }
}
