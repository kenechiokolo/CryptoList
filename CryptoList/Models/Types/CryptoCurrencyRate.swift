//
//  CryptoCurrencyInfo.swift
//  CryptoList
//
//  Created by KC Okolo on 13/01/2023.
//

import Foundation

struct CryptoCurrencyRate: Codable {

    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let openPrice: String
    let lowPrice: String
    let highPrice: String
    let lastPrice: String
    let volume: String
    let bidPrice: String
    let askPrice: String
    let at: Date
}

extension CryptoCurrencyRate: Identifiable {
    
    var id: String {
        symbol + at.formatted()
    }
}

// MARK: Sample Data
extension CryptoCurrencyRate {
    static let sampleData: [CryptoCurrencyRate] = {
        guard let url = Bundle.main.url(forResource: "crypto_sample_data", withExtension: "json") else { return [] }
        guard let data = (try? Data(contentsOf: url)) else { return [] }
        let currencies = (try? JSONDecoder().decode([CryptoCurrencyRate].self, from: data)) ?? []
        return currencies.filter { $0.symbol.hasSuffix("usdt") }
    }()
}
