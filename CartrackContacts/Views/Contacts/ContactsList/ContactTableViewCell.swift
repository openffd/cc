//
//  ContactTableViewCell.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/12/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit

final class ContactTableViewCell: UITableViewCell {
    static let identifier = "ContactTableViewCell"
    
    @IBOutlet private var nameInitialsContainerView: UIView!
    @IBOutlet private var nameInitialsLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        nameInitialsContainerView.layer.cornerRadius = nameInitialsContainerView.frame.width / 2
        nameInitialsContainerView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
