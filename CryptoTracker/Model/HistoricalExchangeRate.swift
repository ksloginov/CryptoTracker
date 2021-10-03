//
//  HistoricalExchangeRate.swift
//  CryptoTracker
//
//  Created by Konstantin Loginov on 03/10/2021.
//

import Foundation

struct HistoricalExchangeRate: Codable {
    let time: Date
    let rate: Double
    
    enum CodingKeys: String, CodingKey {
        case time = "time_open"
        case rate = "rate_open"
    }
}
