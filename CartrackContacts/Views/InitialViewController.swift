//
//  InitialViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/13/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit

final class InitialViewController: UIViewController, SessionServiceDependent {
    let sessionService: SessionService = SessionManager()

    private lazy var landingViewController: LandingViewController = {
        UIStoryboard.landing.instantiateInitialViewController() as! LandingViewController
    }()
    private lazy var contactsSplitViewController: ContactsSplitViewController = {
        UIStoryboard.contacts.instantiateInitialViewController() as! ContactsSplitViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        children.forEach { $0.removeFromParent() }
        
        if let _ = sessionService.getCurrentSession() {
            addChildViewController(contactsSplitViewController)
        } else {
            addChildViewController(landingViewController)
        }
    }
}
