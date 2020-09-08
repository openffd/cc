//
//  UINavigationController+.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/8/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit

extension UINavigationController {
    func hideNavigationBar() {
        navigationBar.setValue(true, forKey: "hidesShadow")
        navigationBar.barStyle = .default
        navigationBar.isTranslucent = false
    }
}
