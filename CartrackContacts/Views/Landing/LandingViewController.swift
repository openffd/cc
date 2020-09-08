//
//  LandingViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit
import Lottie

class LandingViewController: UIViewController {

    @IBOutlet private var animationContainerView: UIView! {
        didSet {
            animationContainerView.backgroundColor = .clear
        }
    }
    
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemOrange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView = .init(name: "Sedan")
        animationView?.frame = animationContainerView.bounds
        animationView?.backgroundColor = .clear
        animationView?.contentMode = .scaleAspectFill
        animationView?.loopMode = .loop
        animationContainerView.addSubview(animationView!)
        animationView?.play()
    }
}
