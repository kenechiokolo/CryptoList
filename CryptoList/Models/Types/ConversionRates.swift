//
//  ConversionRates.swift
//  CryptoList
//
//  Created by KC Okolo on 14/01/2023.
//

import Foundation

struct ConversionRates: Codable {
    let rates: [String:Double]
}

struct ConversionRate {
    
    let code: String
    let rate: Double
    
    init(code: String, rate: Double) {
        self.code = code
        self.rate = rate
    }
}
