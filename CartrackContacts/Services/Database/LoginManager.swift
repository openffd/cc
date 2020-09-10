//
//  LoginManager.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/10/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import RxSwift

protocol LoginService {
    func login(with credentials: LoginCredential) -> Observable<User>
}

protocol LoginServiceDependent {
    var loginService: LoginService { get }
}

final class LoginManager: LoginService {
    let userDatabase: SQLite.Database = .shared
    
    func login(with credential: LoginCredential) -> Observable<User> {
        Observable.create { observer in
            switch self.retrieveUser(with: credential) {
            case .failure(let error):
                observer.onError(error)
            case .success(let user):
                observer.onNext(user)
            }
            return Disposables.create()
        }
    }
    
    private func retrieveUser(with credential: LoginCredential) -> LoginResult {
        guard let user = userDatabase.getUser(username: credential.username) else {
            return .failure(error: .userNotFound)
        }
        
        switch user.validateCredential(credential) {
        case .notMatched:
            return .failure(error: .wrongPassword)
        case .matched:
            return .success(user: user)
        }
    }
}

enum LoginResult {
    case success(user: User)
    case failure(error: LoginError)
}

enum LoginError: Error {
    case userNotFound
    case wrongPassword
    
    var description: String {
        switch self {
        case .userNotFound:
            return "The username entered does not match any account. Please try again."
        case .wrongPassword:
            return "Please make sure your username or password is correct. Please try again."
        }
    }
}
