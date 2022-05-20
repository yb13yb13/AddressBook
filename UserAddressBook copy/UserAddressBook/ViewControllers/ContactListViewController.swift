//
//  ViewController.swift
//  UserAddressBook
//
//  Created by Youcef B on 5/16/22.
//

import UIKit
import SwiftUI

class ContactListViewController: UIViewController {
    var contactListViewModel: ContactListViewController.ContactListViewModel = .init()
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        tableView.register(UINib.init(nibName: "ContactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "contactTableViewCellIdentifier")
        contactListViewModel.loadContacts(on: self)
    }
    
    func navigateToContactDetails(contact: Contact) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ContactDetailsViewControllerIdentifier") as? ContactDetailsViewController else {
            fatalError("ViewController not implemented in storyboard")
        }
        viewController.contact = contact
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - extensions

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListViewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCellIdentifier") as! ContactTableViewCell
        let contact = contactListViewModel.contacts[indexPath.row]
        cell.contact = contact
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contactListViewModel.contacts[indexPath.row]
        navigateToContactDetails(contact: contact)
    }
}

extension ContactListViewController {
    class ContactListViewModel: ObservableObject {
        var contacts = [Contact]()
        
        /**
         Loads the fetched contacts
         - parameter viewController: The view controller that we want to display this on.
         - Note: *ideally we would have a UIViewController as a type and either check if it's ContactListviewController*
         */
        func loadContacts(on viewController: ContactListViewController) {
            contactManager.getContacts { result in
                switch result {
                case .success(let contactsStore):
                    for contact in contactsStore {
                        self.contacts.append(contact)
                    }
                    viewController.tableView.reloadData()
                    
                case .failure(let error):
                    print("there is a json error: \(error.localizedDescription)")
                }
            }
        }
    }
}


