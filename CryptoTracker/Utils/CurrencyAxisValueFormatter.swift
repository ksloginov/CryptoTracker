//
//  CurrencyAxisValueFormatter.swift
//  CryptoTracker
//
//  Created by Konstantin Loginov on 03/10/2021.
//

import Foundation
import Charts

class CurrencyAxisValueFormatter: AxisValueFormatter {
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
    }
}
