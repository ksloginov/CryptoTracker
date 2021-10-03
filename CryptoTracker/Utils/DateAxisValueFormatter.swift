//
//  DateAxisValueFormatter.swift
//  CryptoTracker
//
//  Created by Konstantin Loginov on 03/10/2021.
//

import Foundation
import Charts

class DateAxisValueFormatter: AxisValueFormatter {
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMM d", options: 0, locale: Locale.current)
        return formatter
    }()
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}

