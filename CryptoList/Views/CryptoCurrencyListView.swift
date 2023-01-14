//
//  ContentView.swift
//  CryptoList
//
//  Created by KC Okolo on 13/01/2023.
//

import SwiftUI

struct CryptoCurrencyListView: View {
    
    @ObservedObject var watchList: WatchListManager
    
    var body: some View {
        List {
            Section {
                ForEach(watchList.visibleList) { item in
                    CryptoCurrencyRateView(
                        viewModel: CryptoCurrencyRateViewModel(coin: item, conversionRate: watchList.conversionRate)
                    )
                    .swipeActions(edge: .leading) {
                        if watchList.isSearching {
                            Button {
                                watchList.toggleFavourite(item.symbol)
                            } label: {
                                Image(systemName: watchList.favourites.contains(item.symbol) ? "star.slash" : "star")
                            }
                            .tint(.accentColor)
                        }
                    }
                }
                .onDelete { offsets in
                    watchList.remove(atOffsets: offsets)
                }
                .deleteDisabled(watchList.deleteDisabled)
            } header: {
                Text(watchList.listHeader)
            } footer: {
                Text(watchList.listFooter)
            }
        }
        .refreshable {
            await watchList.refresh()
        }
        .animation(.easeInOut, value: watchList.baseCurrency)
        .animation(.easeInOut, value: watchList.visibleList.count)
        .navigationTitle(watchList.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Picker(watchList.pickerTitle, selection: $watchList.baseCurrency) {
                    ForEach(DisplayCurrency.allCases, id: \.self) { currency in
                        Text(currency.code.uppercased())
                    }
                }
            }
            
            ToolbarItem {
                Text("")
                    .searchable(text: $watchList.searchText)
            }
        }
        .alert(watchList.errorAlertTitle, isPresented: $watchList.isDisplayingErrorAlert) {
            Button {
                
            } label: {
                Text("OK")
            }
        } message: {
            if let localizedDescription = watchList.error?.localizedDescription {
                Text(localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CryptoCurrencyListView(watchList: WatchListManager(list: CryptoCurrencyRate.sampleData))
        }
    }
}
