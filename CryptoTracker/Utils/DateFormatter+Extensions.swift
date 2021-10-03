//
//  DateFormatter+Extensions.swift
//  CryptoTracker
//
//  Created by Konstantin Loginov on 03/10/2021.
//

import Foundation

extension DateFormatter {
    // https://useyourloaf.com/blog/swift-codable-with-custom-dates/
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
