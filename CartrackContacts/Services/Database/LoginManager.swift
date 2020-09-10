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

final class LoginManager: LoginService {
    let userDatabase: SQLite.Database = .shared
    
    func login(with credentials: LoginCredential) -> Observable<User> {
        Observable.create { observer in
            
            observer.onNext(User(id: 0, username: "", digest: "", country: ""))
            return Disposables.create()
        }
    }
    
    private func retrieveUser(with credentials: LoginCredential) throws -> User {
        let result: User? = userDatabase.getUser(username: credentials.username)
        guard let user = result else { throw LoginError.notFound }
        return user
    }
}

enum LoginError: Error {
    case notFound
    case wrongPassword
    
    var description: String {
        switch self {
        case .notFound:
            return "The username entered does not match any account. Please try again."
        case .wrongPassword:
            return "Please make sure your username or password is correct. Please try again."
        }
    }
}
