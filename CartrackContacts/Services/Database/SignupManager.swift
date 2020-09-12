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
    
    func signup(username: String, digest: String, country: String) -> Observable<User> {
        Observable.create { observer in
            return Disposables.create()
        }
    }
    
    private func checkUser(with username: String) -> UsernameAvailability {
        userDatabase.checkUser(username: username)
    }
}
