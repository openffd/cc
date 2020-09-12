//
//  ContactsViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/12/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ContactsViewController: UIViewController, UIScrollViewDelegate {

    private let disposeBag = DisposeBag()
    
    private lazy var contacts: BehaviorRelay<[Contact]> = BehaviorRelay(value: [])
    
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
        }
    }
    
    var isTableViewDelegateSet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "🄲🄲"
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    
        tableView.rx
            .modelSelected(Contact.self)
            .subscribe(onNext: { contact in
                self.showContact(contact: contact)
            })
            .disposed(by: disposeBag)
        
        let loader = RemoteResourceLoader<ContactsRequest>()
        loader.load(networkRequest: .contacts, resourceType: [Contact].self) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let contacts):
                self.contacts.accept(contacts)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let identifier = "ContactTableViewCell"
        if !isTableViewDelegateSet {
            contacts.bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: ContactTableViewCell.self)) { _, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
            
            isTableViewDelegateSet = true
        }

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func showContact(contact: Contact) {
        let viewcontroller = UIStoryboard.contacts.instantiateViewController(withIdentifier: "ContactDetailTableViewController") as! ContactDetailTableViewController
        viewcontroller.contact = contact
        showDetailViewController(viewcontroller, sender: nil)
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
