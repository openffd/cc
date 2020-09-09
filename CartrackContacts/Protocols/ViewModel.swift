//
//  ViewModeled.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/9/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
}

protocol ViewModeled: AnyObject {
    associatedtype AssociatedViewModel: ViewModel
    
    static func instantiate(with viewModel: AssociatedViewModel) -> Self
    
    func configure(with viewModel: AssociatedViewModel)
}
