//
//  ContactTableViewCell.swift
//  UserAddressBook
//
//  Created by Youcef B on 5/16/22.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    
    var contact: Contact? {
        didSet {
            if let name = contact?.fullName,
               let imageUrl = contact?.imageUrl {
                contactName.text = name
                contactImageView.loadImageUsingCacheWithUrlString(imageUrl)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contactImageView.makeRounded()
    }
}

