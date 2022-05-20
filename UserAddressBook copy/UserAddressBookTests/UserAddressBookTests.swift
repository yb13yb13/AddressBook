//
//  UserAddressBookTests.swift
//  UserAddressBookTests
//
//  Created by Youcef B on 5/16/22.
//

import XCTest
@testable import UserAddressBook

class UserAddressBookTests: XCTestCase {
    var contactManager = ContactServiceObjectManager()
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - Get Contact Test
    func testGettingValidContactObject() {
        let expectation = self.expectation(description: "Contact Manager - Get Contacts")
        contactManager.getContacts { result in
            switch result {
            case .success:
                XCTAssert(true)
                expectation.fulfill()
            case .failure:
                XCTAssert(false)
                expectation.isInverted = true
            }
        }
        wait(for: [expectation], timeout: 6)
    }
}
