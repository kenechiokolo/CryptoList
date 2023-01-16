//
//  Currency.swift
//  CryptoList
//
//  Created by KC Okolo on 13/01/2023.
//

import Foundation

enum DisplayCurrency: String, CaseIterable {
    
    case sek, usd, gbp, hkd
    
    var code: String {
        rawValue
    }
}
