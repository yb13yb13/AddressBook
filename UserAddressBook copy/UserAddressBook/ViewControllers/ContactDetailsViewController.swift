//
//  ContactDetailsViewController.swift
//  UserAddressBook
//
//  Created by Youcef B on 5/17/22.
//

import UIKit

/**
 A class representing the contact details view
 */
class ContactDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var contactProfileImageView: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhoneNumber: UILabel!
    @IBOutlet weak var contactDOB: UILabel!
    @IBOutlet weak var contactAddress: UILabel!
    
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.configureView()
        }
    }
    
    
    // MARK: - Methods
    
    /**
     configures the view elements with the contact data
     - parameter contact: The contact to show the data for
     
     - Note:  *Ideally the gender check has to be in the model with an enum to handle different genders cases and maybe have a computed property, something like(in this case only two genders) isMan: Bool { ... }.*
     */
    func configureView() {
        // Navigation
        title = contact?.fullName
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Contact Data
        guard let contact = contact else { return }
        let imageUrl = contact.imageUrl ?? ""
        let fullName = contact.fullName ?? ""
        let cellNumber = contact.cellPhoneNumber
        let dob = contact.birthDate ?? Date()
        
        // Assign data to the UI elements
        self.contactName.text = fullName
        self.contactPhoneNumber.text = cellNumber
        self.contactDOB.text = dob.humanReadable()
        self.contactAddress.text = contact.formattedForTwoLines(contact: contact)
        self.contactProfileImageView.loadImageUsingCacheWithUrlString(imageUrl)
        // Make profile picture round
        self.contactProfileImageView.makeRounded()
    }
}



