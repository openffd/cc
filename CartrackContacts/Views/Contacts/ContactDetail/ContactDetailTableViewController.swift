//
//  ContactDetailTableViewController.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/12/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import UIKit
import MapKit

final class ContactDetailTableViewController: UITableViewController {

    var contact: Contact? = nil
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var nameInitialsLabel: UILabel! {
        didSet {
            nameInitialsLabel.font = .helveticaNeueBold(size: 32)
            nameInitialsLabel.textColor = .white
        }
    }
    @IBOutlet private var nameInitialsContainerView: UIView! {
        didSet {
            nameInitialsContainerView.layer.cornerRadius = nameInitialsContainerView.frame.width / 2
        }
    }
    @IBOutlet private var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .helveticaNeueBold(size: 24)
            nameLabel.textColor = .black
        }
    }
    
    @IBOutlet private var usernameTextLabel: UILabel!
    @IBOutlet private var usernameLabel: UILabel!
    
    @IBOutlet private var emailTextLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    
    @IBOutlet private var phoneTextLabel: UILabel!
    @IBOutlet private var phoneLabel: UILabel!
    
    @IBOutlet private var websiteTextLabel: UILabel!
    @IBOutlet private var websiteLabel: UILabel!
    
    @IBOutlet private var addressTextLabel: UILabel!
    @IBOutlet private var address1Label: UILabel!
    @IBOutlet private var address2Label: UILabel!
    @IBOutlet private var mapContainerView: UIView!
    @IBOutlet private var mapView: MKMapView!
    
    @IBOutlet private var companyTextLabel: UILabel!
    @IBOutlet private var companyNameLabel: UILabel!
    @IBOutlet private var companyCatchPhraseLabel: UILabel!
    @IBOutlet private var companyBusinessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 64.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        setupFieldTextLabels()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(openMapForPlace))
        mapView.addGestureRecognizer(recognizer)
        
        if let location = contact?.address.location {
            let loc = CLLocation(latitude: location.latitude.toDouble, longitude: location.longitude.toDouble)
            let region = MKCoordinateRegion( center: loc.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
            
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
            mapView.setCameraZoomRange(zoomRange, animated: true)
        }
        
        setupFieldValues()
    }
    
    private func setupFieldValues() {
        guard let contact = self.contact else { return }
        
        nameInitialsLabel.text = contact.initials
        nameInitialsContainerView.backgroundColor = contact.color
        nameLabel.text = contact.name
        
        usernameLabel.text = contact.username
        emailLabel.text = contact.displayEmail
        phoneLabel.text = contact.phone
        websiteLabel.text = contact.website
        
        companyNameLabel.text = contact.company.name
        companyBusinessLabel.text = contact.company.catchPhrase
        companyCatchPhraseLabel.text = contact.company.business
        
        let address = contact.address
        address1Label.text = address.line1
        address2Label.text = address.line2
    }
    
    private func setupFieldTextLabels() {
        let fieldTextLabels: [UILabel] = [
            usernameTextLabel,
            emailTextLabel,
            phoneTextLabel,
            websiteTextLabel,
            addressTextLabel,
            companyTextLabel,
        ]
        fieldTextLabels.forEach { label in
            label.font = .helveticaNeue(size: 12)
            label.textColor = .lightGray
        }
    }
    
    @objc func openMapForPlace() {
        guard let contact = self.contact else { return }
        let latitude = contact.address.location.latitude.toDouble
        let longitude = contact.address.location.longitude.toDouble
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(contact.address.line1)\n\(contact.address.line2)"
        mapItem.openInMaps(launchOptions: options)
    }
}

extension ContactDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let _ = contact else { return .zero }
        switch indexPath.row {
        case 6:
            return 300
        default:
            return UITableView.automaticDimension
        }
    }
}
