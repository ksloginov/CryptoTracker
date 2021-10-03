//
//  DataService.swift
//  CryptoTracker
//
//  Created by Konstantin Loginov on 03/10/2021.
//

import Foundation
import Alamofire

struct DataService {
    
    private static let token = "26807AD6-C5AF-41AD-BE0B-D6A1049C182A"
    let exchangeRateURL = "https://rest.coinapi.io/v1/exchangerate/%@/%@?apikey=\(token)"
    let historicalExchangeRatesURL = "https://rest.coinapi.io/v1/exchangerate/%@/%@/history?period_id=%@&time_start=%@T00:00:00&apikey=\(token)"
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func loadHistoricalExchangeRate(_ token: CryptoCurrency, startingDate: Date, period: String,  completion: @escaping ([HistoricalExchangeRate]?) -> Void) {
        
        let url = String(format: historicalExchangeRatesURL, token.rawValue, "USD", period, DataService.formatter.string(from: startingDate))
        AF.request(url).response { response in
            var result: [HistoricalExchangeRate]? = nil
            if let data = response.data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                result = try? decoder.decode([HistoricalExchangeRate].self, from: data)
            }
            
            completion(result)
        }
    }
    
    func loadExchangeRate(_ token: CryptoCurrency, completion: @escaping (ExchangeRate?) -> Void) {
        let url = String(format: exchangeRateURL, token.rawValue, "USD")
        AF.request(url).response { response in
            var result: ExchangeRate? = nil
            if let data = response.data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                result = try? decoder.decode(ExchangeRate.self, from: data)
            }
            
            completion(result)
        }
    }
    
}
