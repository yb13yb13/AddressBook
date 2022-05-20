//
//  NetworkManager.swift
//  UserAddressBook
//
//  Created by Youcef B on 5/16/22.
//

import Foundation
import SwiftyJSON

let contactManager = ContactServiceObjectManager.shared

final class ContactServiceObjectManager {
    static let shared = ContactServiceObjectManager()
    private var contactsStore = [Contact]()

    typealias NetworkResponseClosure = (_ result: Swift.Result<[Contact], Error>) -> Void
    
    
    /**
     Method to get the contacts list
     - parameter completionHandler; escaping asynchronous to capture our contact
    */
    func getContacts(completionHandler: @escaping NetworkResponseClosure) {
        let urlString = "https://randomuser.me/api/?results=100"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let userData = try! JSON(data: data)
                if let results = userData["results"].array {
                    
                    let contactsDictionaries = results.compactMap({ $0.dictionaryObject })
                    
                    do {
                        let json = try JSONSerialization.data(withJSONObject: contactsDictionaries)
                        let contacts = try JSONDecoder().decode([Contact].self, from: json)
                        self.contactsStore = contacts
                        completionHandler(.success(contacts))
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        
    }
}
