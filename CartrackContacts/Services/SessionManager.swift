//
//  SessionManager.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/13/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

protocol SessionService {
    func getCurrentSession() -> Session?
    func saveSession(_ session: Session)
    func deleteCurrentSession()
}

protocol SessionServiceDependent {
    var sessionService: SessionService { get }
}

final class SessionManager: SessionService {
    
    private let standardUserDefaults: UserDefaults = .standard
    private static let sessionKey = "SavedSession"
    
    func getCurrentSession() -> Session? {
        guard let data = standardUserDefaults.object(forKey: SessionManager.sessionKey) as? Data else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let session = try? decoder.decode(Session.self, from: data) else {
            return nil
        }
        return session
    }
    
    func saveSession(_ session: Session) {
        let encoder = JSONEncoder()
        guard let encodedSession = try? encoder.encode(session) else { return }
        standardUserDefaults.set(encodedSession, forKey: SessionManager.sessionKey)
    }
    
    func deleteCurrentSession() {
        standardUserDefaults.removeObject(forKey: SessionManager.sessionKey)
    }
}
