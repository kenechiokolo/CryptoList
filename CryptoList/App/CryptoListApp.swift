//
//  CryptoListApp.swift
//  CryptoList
//
//  Created by KC Okolo on 13/01/2023.
//

import SwiftUI

@main
struct CryptoListApp: App {
    
    @StateObject var watchList = WatchListManager(
        favourites: UserDefaults.standard.value(forKey: "favourites") as? [String]
    )
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CryptoCurrencyListView(watchList: watchList)
            }
        }
    }
}
