//
//  Contact.swift
//  UserAddressBook
//
//  Created by Youcef B on 5/16/22.
//

import Foundation
import UIKit

/** Class representng the Contact model
 */
class Contact: Decodable, Identifiable {
    
    // MARK: - Properties
    
    var uniqueID = UUID()
    var firstName: String?
    var lastName: String?
    var gender: String?
    var title: String?
    var birthDateString: String?
    var email: String?
    var cellPhoneNumber: String?
    var imageUrl: String?
    var nationality: String?
    var streetName: String?
    var streetNumber: Int?
    var city: String?
    var state: String?
    var country: String?
    var postalCode: String?
    var latitude: String?
    var longitude: String?
    var offset: Double?
    var description: String?
    
    // Emum for the postal code code(zipcode). Seems like in the Api you guys sent me there is String type and sometimes Int coming back. What this will do
    enum PostalCodeCustomType: Codable {
      case int(Int)
      case string(String)

        // Try to decode
      init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
          self = try .int(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
          do {
            self = try .string(container.decode(String.self))
          } catch DecodingError.typeMismatch {
            throw DecodingError.typeMismatch(PostalCodeCustomType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "*Problem decoding the zip code*: Wrong Type..."))
          }
        }
      }
    }
    
    // Coding keys enum for root Array tree
    enum RootCodingKeys: String, CodingKey {
        case email
        case imageUrl = "picture"
        case nationality = "nat"
        case name
        case location
        case birthDateString = "dob"
        case phoneNumber = "cell"
        case gender
        case id
    }
    
    // Coding enum for the name dictionary tree
    enum NameCodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
        case title = "title"
    }
    
    // Coding enum for the birthday dictionary tree
    enum BirthDateCodingKeys: String, CodingKey {
        case birthDate = "date"
        case age
    }
    
    // Coding enum for the profile picture dictionary tree
    enum ProfilePictureCodingKeys: String, CodingKey {
        case profilePicture = "medium"
    }
    
    // Coding enum for the location dictionary tree
    enum ContactLocationRootCodingKeys: String, CodingKey {
        case street
        case coordinates
        case timezone
        case city
        case state
        case country = "country"
        case postalCode = "postcode"
    }
    
    // Coding enum for the street dictionary tree
    enum StreetCodingKeys: String, CodingKey {
        case streetName = "name"
        case streetNumber = "number"
    }
    
    // Coding enum for the coordinates dictionary tree
    enum CoordinatesCodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    
    /// Computed property that returns a String representing the customer's full name in the format of "John Doe"
    var fullName: String? {
        let nameComponents: [String] = [firstName, lastName].compactMap { $0 }
        return nameComponents.joined(separator: " ")
    }
    
    /**
        Computed property to make it flexible working with birthday date
    */
    var birthDate: Date? {
        get {
            guard let dateString = birthDateString else {
                return nil
            }
            return Date(stringDate: dateString)
        }
        set {
            birthDateString = newValue?.timeStampFormatter()
        }
    }
    
    /**
     Function to format the string into two seperate lines for the address of our contact
     */
    func formattedForTwoLines(contact: Contact) -> String {
        guard let streetNumber = contact.streetNumber,
              let streetName = contact.streetName,
              let city = contact.city,
              let state = contact.state,
              let zipcode = contact.postalCode,
              let country = contact.country else { return "problem populating address" }
        
        let addressStringArray: [String] = ["\(streetNumber)", streetName, city, state, country]
        let address = addressStringArray.joined(separator: ", ")
        let validAddress = [address, "\(zipcode)"].filter { !$0.isEmpty}

        let fullAddress = validAddress.joined(separator: "\r\n")
        return fullAddress
    }
    
    
    // MARK: - Inits
    
    /// Decoding init
    required convenience init(from decoder: Decoder) throws {
        self.init()
        // Root Container
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        
        // Email
        email = try container.decode(String.self, forKey: .email)
        
        // Gender
        gender = try container.decode(String.self, forKey: .gender)
        
        // Cell Phone
        cellPhoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        
        // Name Container
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        firstName = try nameContainer.decode(String.self, forKey: .firstName)
        lastName = try nameContainer.decode(String.self, forKey: .lastName)
        title = try nameContainer.decode(String.self, forKey: .title)
        
        // Date Of Birth
        let dobContainer = try container.nestedContainer(keyedBy: BirthDateCodingKeys.self, forKey: .birthDateString)
        let dateString = try? dobContainer.decode(String.self, forKey: .birthDate)
        if dateString != nil {
            let createdDateFromString = Date(stringDate: dateString!)
            birthDate = createdDateFromString
        }
        
        // Location Container
        let locationContainer = try container.nestedContainer(keyedBy: ContactLocationRootCodingKeys.self, forKey: .location)
        city = try locationContainer.decode(String.self, forKey: .city)
        state = try locationContainer.decode(String.self, forKey: .state)
        country = try locationContainer.decode(String.self, forKey: .country)
        
         //postal code coming from API seems to be different, some are String and some are number
        let postalCodeString = try? locationContainer.decode(String.self, forKey: .postalCode)
        let postalCodeInt = try? locationContainer.decode(Int.self, forKey: .postalCode)
        postalCode = postalCodeString ?? (postalCodeInt == 0 ? nil : "\(postalCode ?? "")")
        
        // Street Container
        let streetContainer = try locationContainer.nestedContainer(keyedBy: StreetCodingKeys.self, forKey: .street)
        streetNumber = try streetContainer.decode(Int.self, forKey: .streetNumber)
        streetName = try streetContainer.decode(String.self, forKey: .streetName)
        
        
        // Coordinates Container
        let coordinatesContainer = try locationContainer.nestedContainer(keyedBy: CoordinatesCodingKeys.self, forKey: .coordinates)
        longitude = try coordinatesContainer.decode(String.self, forKey: .longitude)
        latitude = try coordinatesContainer.decode(String.self, forKey: .latitude)
        
        // Image
        let profilePictureContainer = try container.nestedContainer(keyedBy: ProfilePictureCodingKeys.self, forKey: .imageUrl)
        imageUrl = try profilePictureContainer.decode(String.self, forKey: .profilePicture)
        
        // Nationality
        nationality = try container.decode(String.self, forKey: .nationality)
        
        
        
    }
    
    
    /// Convenient init to create a contact object
    convenience init(withContact contact: Contact) {
        self.init()
        self.firstName = contact.firstName
        self.lastName = contact.lastName
        self.title = contact.title
        self.birthDateString = contact.birthDateString
        self.email = contact.email
        self.imageUrl = contact.imageUrl
        self.nationality = contact.nationality
        self.country = contact.country
        self.gender = contact.gender
        self.cellPhoneNumber = contact.cellPhoneNumber
        self.streetName = contact.streetName
        self.streetNumber = contact.streetNumber
        self.city = contact.city
        self.state = contact.state
        self.postalCode = contact.postalCode
        self.latitude = contact.latitude
        self.longitude = contact.longitude
    }
}

// MARK: - Extensions

extension Contact: ObservableObject { }
