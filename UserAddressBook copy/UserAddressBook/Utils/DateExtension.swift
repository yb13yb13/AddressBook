//
//  Extensions.swift
//  UserAddressBook
//
//  Created by Youcef B on 5/19/22.
//

import Foundation


// MARK: - Date

extension Date {
    // Init to get data
    init?(stringDate: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = formatter.date(from: stringDate) {
            self = date
        } else {
            return nil
        }
    }
    
    /**
     A convenience method that converts an NSDate into a timestampformatted String for the REST API
     */
    func timeStampFormatter() -> String {
        let prefix = "/Date("
        let suffix = ")/"
        
        let timeInterval = self.timeIntervalSince1970
        let dateInMilliseconds = Int64(timeInterval * 1000)
        
        let secondsFromGMT = DateFormatter().timeZone.secondsFromGMT(for: self)
        
        let timeZoneAdjustment = secondsFromGMT / 36
        
        var sign = "-"
        if timeZoneAdjustment > 0 {
            sign = "+"
        }
        
        let timeZoneAdjustmentString = String(format: "%04d", abs(timeZoneAdjustment))
        
        let timeStamp = prefix + String(dateInMilliseconds) + sign + timeZoneAdjustmentString + suffix
        return timeStamp
    }
    
    /**
     Returns Date in human readable format, localized with template "MM/dd/yyyy"
     */
    func humanReadable() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let string = dateFormatter.string(from: self)
        return string
    }
}
