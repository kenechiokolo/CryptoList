//
//  CryptoCurrencyRateViewModel.swift
//  CryptoList
//
//  Created by KC Okolo on 14/01/2023.
//

import SwiftUI


class CryptoCurrencyRateViewModel: ObservableObject {
    
    init(coin: CryptoCurrencyRate, conversionRate: ConversionRate) {
        self.coin = coin
        self.conversionRate = conversionRate
    }
    
    private var conversionRate: ConversionRate
    
    private let coin: CryptoCurrencyRate
    private let numberFormatter = NumberFormatter()
}

extension CryptoCurrencyRateViewModel {
    
    var displayName: String {
        coin.baseAsset.uppercased()
    }
    
    var lastPrice: String {
        
        guard let lastPrice = numberFormatter.number(from: coin.lastPrice) as? Double else { return coin.lastPrice }
        
        let value = round((lastPrice * conversionRate.rate) * 1000) / 1000.0
        
        return value.formatted(.currency(code: conversionRate.code))
    }
    
    var changeBackgroundColor: Color {
        percentageChange > 0 ? .green.opacity(0.8) : .red.opacity(0.8)
    }
    
    var percentageChange: Double {
        
        guard
            let lastPrice = numberFormatter.number(from: coin.lastPrice) as? Double,
            let openPrice = numberFormatter.number(from: coin.openPrice) as? Double
        else {
            return 0
        }
        
        let percentageChange = (lastPrice - openPrice) / openPrice
        
        return round(percentageChange * 10000) / 10000.0
    }
}
