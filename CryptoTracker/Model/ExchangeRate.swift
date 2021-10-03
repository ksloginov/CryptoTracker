//
//  ExchangeRate.swift
//  CryptoTracker
//
//  Created by Konstantin Loginov on 03/10/2021.
//

import Foundation

struct ExchangeRate: Codable {
    let time: Date
    let rate: Double
}
