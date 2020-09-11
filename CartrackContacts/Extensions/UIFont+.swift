//
//  UIFont+.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/11/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit

extension UIFont {
    static func helveticaNeue(size: CGFloat) -> UIFont {
        UIFont(name: "HelveticaNeue", size: size)!
    }
    
    static func helveticaNeueBold(size: CGFloat) -> UIFont {
        UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    
    static func helveticaNeueCondensedBold(size: CGFloat) -> UIFont {
        UIFont(name: "HelveticaNeue-CondensedBold", size: size)!
    }
    
    static func helveticaNeueCondensedBlack(size: CGFloat) -> UIFont {
        UIFont(name: "HelveticaNeue-CondensedBlack", size: size)!
    }
}
