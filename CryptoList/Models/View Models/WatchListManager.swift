//
//  CurrencyList.swift
//  CryptoList
//
//  Created by KC Okolo on 13/01/2023.
//

import SwiftUI

class WatchListManager: ObservableObject {
    
    @Published var isDisplayingErrorAlert = false
    
    @Published var baseCurrency = DisplayCurrency.usd
    @Published var favourites = [String]()
    @Published var searchText = ""
    
    private (set) var fetchDate = Date()
    
    var error: NSError?
    
    let title = "Watchlist"
    let pickerTitle = "Base Currency"
    let errorAlertTitle = "Oops! Something went wrong..."
    
    init(list: [CryptoCurrencyRate] = []) {
        self.favourites = UserDefaults.standard.value(forKey: "favourites") as? [String] ?? []
        
        self.completeList = list
        self.list = completeList.filter { favourites.contains($0.symbol) }
        
        guard list.isEmpty else { return }
        Task {
            await refresh()
        }
    }
    
    private let requestManager = RequestManager()
    
    private var completeList = [CryptoCurrencyRate]()
    private var conversionRates: [String:Double] = [:]
    
    @Published private var list = [CryptoCurrencyRate]()
}

// MARK: Refresh
extension WatchListManager {
    
    func refresh() async {
        
        do {
            let latestCurrencyPairs: [CryptoCurrencyRate] = try await requestManager.fetch(for: .marketDataLast24Hours)
            let latestExchangeRates: ConversionRates = try await requestManager.fetch(for: .currencyConversionRates)
            
            DispatchQueue.main.async { [weak self] in
                self?.completeList = latestCurrencyPairs.filter { $0.symbol.hasSuffix("usdt") }
                self?.refreshVisibleList()
                self?.conversionRates = latestExchangeRates.rates
                self?.fetchDate = Date.now
            }
            
        } catch {
            
            self.error = error as NSError
            DispatchQueue.main.async { [weak self] in
                self?.isDisplayingErrorAlert = true
            }
        }
        
    }
    
    private func refreshVisibleList() {
        
        if UserDefaults.standard.array(forKey: "favourites") as? [String] == nil {
            favourites = completeList.prefix(10).compactMap({ $0.symbol })
        }
        
        list = completeList.filter { favourites.contains($0.symbol) }
        UserDefaults.standard.set(favourites, forKey: "favourites")
    }
}

// MARK: Managing Favourites
extension WatchListManager {
    
    func toggleFavourite(_ symbol: String) {
        
        if let index = favourites.firstIndex(of: symbol) {
            favourites.remove(at: index)
        } else {
            favourites.append(symbol)
        }
        
        refreshVisibleList()
    }
    
    func remove(atOffsets offsets: IndexSet) {
        let symbols = offsets.compactMap { list[$0].symbol }
        for symbol in symbols {
            toggleFavourite(symbol)
        }
    }
}

// MARK: Public Getters
extension WatchListManager {
    
    var visibleList: [CryptoCurrencyRate] {
        searchText.isEmpty ? list : filteredList
    }
    
    var deleteDisabled: Bool {
        !searchText.isEmpty
    }
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    var listHeader: String {
        let prefix = isSearching ? "All" : "Favourites"
        return "\(prefix) (\(currencyCount))"
    }
    
    var listFooter: String {
        fetchDate.formatted(date: .abbreviated, time: .complete)
    }
    
    var conversionRate: ConversionRate {
        ConversionRate(code: baseCurrency.code.uppercased(), rate: conversionRates[baseCurrency.code.uppercased()] ?? 0)
    }
}

// MARK: Private Helper Methods & Getters
private extension WatchListManager {
    
    var filteredList: [CryptoCurrencyRate] {
        completeList.filter { $0.symbol.lowercased().contains(searchText.lowercased()) }
    }
    
    var currencyCount: Int {
        visibleList.count
    }
}
