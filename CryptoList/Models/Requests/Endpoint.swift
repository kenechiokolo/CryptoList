//
//  Endpoint.swift
//  CryptoList
//
//  Created by KC Okolo on 14/01/2023.
//

import Foundation

enum Endpoint {
    case marketDataLast24Hours
    case currencyConversionRates
    
    var url: URL {
        switch self {
            
        case .marketDataLast24Hours:
            return URL(string: "https://api.wazirx.com/sapi/v1/tickers/24hr")!
        case .currencyConversionRates:
            return URL(string: "https://api.exchangerate.host/latest?base=USD")!
        }
    }
    
    var type: Decodable.Type {
        switch self {
        case .marketDataLast24Hours:
            return [CryptoCurrencyRate].self
        case .currencyConversionRates:
            return ConversionRates.self
        }
    }
}
