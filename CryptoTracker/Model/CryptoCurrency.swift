//
//  CryptoCurrency.swift
//  CryptoTracker
//
//  Created by Konstantin Loginov on 03/10/2021.
//

import UIKit

enum CryptoCurrency: String, CaseIterable {
    case BTC
    case ETH
    case XRP
    case DOGE
    
    var symbol: String {
        switch self {
        case .BTC:
            return "₿"
        case .ETH:
            return "Ξ"
        case .XRP:
            return "✕"
        case .DOGE:
            return "Ð"
        }
    }
    
    var color: UIColor? {
        switch self {
        case .BTC:
            return UIColor(named: "btc")
        case .ETH:
            return UIColor(named: "eth")
        case .XRP:
            return UIColor(named: "xrp")
        case .DOGE:
            return UIColor(named: "doge")
        }
    }
    
    var name: String {
        switch self {
        case .BTC:
            return "Bitcoin"
        case .ETH:
            return "Ethereum"
        case .XRP:
            return "XRP"
        case .DOGE:
            return "Dogecoin"
        }
    }
}
