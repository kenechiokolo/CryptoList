//
//  PriceCard.swift
//  CryptoList
//
//  Created by KC Okolo on 13/01/2023.
//

import SwiftUI

struct CryptoCurrencyRateView: View {
    
    @ObservedObject var viewModel: CryptoCurrencyRateViewModel
    
    private let padding = 6.0
    
    var body: some View {
        HStack {
            Text(viewModel.displayName)
                .font(.title2)
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.lastPrice)
                    .font(.headline)
                    .padding(padding)
                Text(viewModel.percentageChange, format: .percent)
                    .font(.subheadline)
                    .padding(padding)
                    .background(
                        RoundedRectangle(cornerRadius: padding)
                            .foregroundColor(viewModel.changeBackgroundColor)
                    )
                
            }
        }
    }
}

struct PriceCard_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CryptoCurrencyRateView(
                viewModel: CryptoCurrencyRateViewModel(
                    coin: CryptoCurrencyRate.sampleData.randomElement()!,
                    conversionRate: ConversionRate(code: "SEK", rate: 10)
                )
            )
        }
    }
}
