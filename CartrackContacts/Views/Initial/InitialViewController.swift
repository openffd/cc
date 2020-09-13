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
    private var contactsSplitViewController: ContactsSplitViewController {
        let storyboard: UIStoryboard = .contacts
        let viewController = storyboard.instantiateInitialViewController() as! ContactsSplitViewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        children.forEach { $0.remove() }
        
        if !sessionService.hasExistingSession() {
            addChildViewController(landingViewController)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if sessionService.hasExistingSession() {
            present(contactsSplitViewController, animated: false, completion: nil)
        }
    }
}
