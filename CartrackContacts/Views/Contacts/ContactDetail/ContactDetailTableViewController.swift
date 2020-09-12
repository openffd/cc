//
//  ContactDetailTableViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/12/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit

final class ContactDetailTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameInitialsContainerView: UIView! {
        didSet {
            nameInitialsContainerView.layer.cornerRadius = nameInitialsContainerView.frame.width/2
        }
    }
    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
   
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyCatchPhraseLabel: UILabel!
    @IBOutlet weak var companyBusinessLabel: UILabel!
    
    @IBOutlet weak var companyCell: UITableViewCell!
    @IBOutlet weak var addressCell: UITableViewCell!

    var contact: Contact? = nil

    var bigCellTag = 1001
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        
        tableView.estimatedRowHeight = 64.0
        tableView.rowHeight = UITableView.automaticDimension
        
        addressCell.tag = bigCellTag
        companyCell.tag = bigCellTag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let contact = contact {
            // Populate Data
            nameInitialsLabel.text = contact.initials
            nameInitialsContainerView.backgroundColor = contact.color
            nameLabel.text = contact.name
            
    
            usernameLabel.text = contact.username
            emailLabel.text = contact.email.lowercased()
            phoneLabel.text = contact.phone
            websiteLabel.text = contact.website
            
            let address = contact.address
            addressTextView.text = "\(address.suite)\n\(address.street)\n\(address.city) \(address.zipcode)"
            addressTextView.isEditable = false
            addressTextView.isScrollEnabled = false
            
            companyNameLabel.text = "  \(contact.company.name)"
            companyBusinessLabel.text = "  \(contact.company.business)"
            companyCatchPhraseLabel.text = "  \"\(contact.company.catchPhrase)\""
        }
        
    }
    
    //MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if contact == nil {
            headerView.isHidden = true
            return 0
        } else {
            headerView.isHidden = false
            return UITableView.automaticDimension
        }
    }
}
