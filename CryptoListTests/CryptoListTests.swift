//
//  CryptoListTests.swift
//  CryptoListTests
//
//  Created by KC Okolo on 13/01/2023.
//

import XCTest
@testable import CryptoList

final class CryptoListTests: XCTestCase {
    
    private let testFavourite = "btcusdt"
    private let testFavourites = ["xrpusdt", "ethusdt", "ltcusdt", "btcusdt"]
    
    private let sampleData: [CryptoCurrencyRate] = {
        let bundle = Bundle(for: WatchListManager.self)
        guard let url = bundle.url(forResource: "crypto_sample_data", withExtension: "json") else { return [] }
        guard let data = (try? Data(contentsOf: url)) else { return [] }
        let currencies = (try? JSONDecoder().decode([CryptoCurrencyRate].self, from: data)) ?? []
        return currencies.filter { $0.symbol.hasSuffix("usdt") }
    }()
    
    func testDeletionRemovesItemFromFavourites() {
        let watchList = WatchListManager(completeList: sampleData, favourites: testFavourites)
        XCTAssertTrue(watchList.favourites.contains(testFavourite))
        watchList.remove(atOffsets: IndexSet(integer: 3))
        XCTAssertFalse(watchList.favourites.contains(testFavourites))
    }
    
    func testToggleFavouritesAddsFavourite() {
        let watchList = WatchListManager(completeList: sampleData, favourites: [])
        XCTAssertFalse(watchList.favourites.contains(testFavourite))
        watchList.toggleFavourite(testFavourite)
        XCTAssertTrue(watchList.favourites.contains(testFavourite))
    }
    
    func testToggleFavouritesRemovesFavourite() {
        let watchList = WatchListManager(completeList: sampleData, favourites: testFavourites)
        XCTAssertTrue(watchList.favourites.contains(testFavourite))
        watchList.toggleFavourite(testFavourite)
        XCTAssertFalse(watchList.favourites.contains(testFavourite))
    }
    
    func testSearchCorrectlyFiltersResults() {
        let watchList = WatchListManager(completeList: sampleData, favourites: testFavourites)
        let searchTerm = "ftt"
        let resultCount = sampleData.filter { $0.symbol.lowercased().contains(searchTerm) }.count
        watchList.searchText = searchTerm
        XCTAssertEqual(resultCount, watchList.visibleList.count)
    }
    
    func testCryptoCurrencyRateViewModelGivesExpectedStringWhenConverted() {
        
        let watchList = WatchListManager(completeList: sampleData, favourites: testFavourites)
        let currencyRate = watchList.visibleList[0]
        let lastPrice = (NumberFormatter().number(from: currencyRate.lastPrice) as? Double) ?? 0
        
        watchList.conversionRates = ["USD" : 1, "SEK": 10]
        watchList.baseCurrency = .sek
        
        let convertedLastPrice = (lastPrice * 10).formatted(.currency(code: "SEK"))
        let currencyRateViewModel = CryptoCurrencyRateViewModel(coin: currencyRate, conversionRate: watchList.conversionRate)
        
        XCTAssertTrue(currencyRateViewModel.lastPrice == convertedLastPrice)
    }
    
    func testCryptoCurrencyRateViewModelGivesExpectedString() {
        
        let watchList = WatchListManager(completeList: sampleData, favourites: testFavourites)
        let currencyRate = watchList.visibleList[0]
        let lastPrice = (NumberFormatter().number(from: currencyRate.lastPrice) as? Double) ?? 0
        let lastPriceString = lastPrice.formatted(.currency(code: "USD"))
        
        watchList.conversionRates = ["USD" : 1, "SEK": 10]
        
        let currencyRateViewModel = CryptoCurrencyRateViewModel(coin: currencyRate, conversionRate: watchList.conversionRate)
        
        XCTAssertTrue(currencyRateViewModel.lastPrice == lastPriceString)
    }
}
