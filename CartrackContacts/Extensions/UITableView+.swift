//
//  UITableView+.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/13/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func showActivityIndicator() {
        let activityView = UIActivityIndicatorView(style: .large)
        backgroundView = activityView
        activityView.startAnimating()
    }
    
    func hideActivityIndicator() {
        backgroundView = nil
    }
}
