//
//  UIViewController+.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/9/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(for error: Error) {
        let alertController = UIAlertController(
            title: "",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alertController.addAction(.init(title: "Okay", style: .default))
        present(alertController, animated: true)
    }
    
    func presentAlert(for message: String) {
        let alertController = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(.init(title: "Okay", style: .default))
        present(alertController, animated: true)
    }
}

extension UIViewController {
    func addChildViewController(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func detachFromParent() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
