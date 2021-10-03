//
//  DateRange.swift
//  CryptoTracker
//
//  Created by Konstantin Loginov on 03/10/2021.
//

import Foundation

enum DateRange: String, CaseIterable {
    case FiveDays = "5D"
    case OneMonth = "1M"
    case SixMonths = "6M"
    case YearToDate = "YTD"
    case OneYear = "1Y"
    
    var date: Date? {
        switch self {
        case .FiveDays:
            return Calendar.current.date(byAdding: .day, value: -5, to: Date())
        case .OneMonth:
            return Calendar.current.date(byAdding: .month, value: -1, to: Date())
        case .SixMonths:
            return Calendar.current.date(byAdding: .month, value: -6, to: Date())
        case .YearToDate:
            return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Date()))
        case .OneYear:
            return Calendar.current.date(byAdding: .year, value: -1, to: Date())
        }
    }
    
    var period: String {
        if self == .OneYear {
            return "5DAY"
        } else if self == .SixMonths {
            return "2DAY"
        } else if self == .YearToDate {
            if let date = date, let daysDiff = Calendar.current.dateComponents([.day], from: date, to: Date()).day {
                return daysDiff > 100 ? "5DAY" : "1DAY"
            }
        }
        
        return "1DAY"
    }
}
