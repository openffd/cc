//
//  UIView+.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/12/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func rounded() {
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let shapeLayer = CAShapeLayer()
        let rect = CGRect(x: bounds.midX - width / 2, y: bounds.midY - width / 2, width: width, height: width)
        shapeLayer.path = UIBezierPath(ovalIn: rect).cgPath
        self.layer.mask = shapeLayer
    }
}
