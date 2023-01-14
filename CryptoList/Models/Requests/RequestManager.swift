//
//  RequestManager.swift
//  CryptoList
//
//  Created by KC Okolo on 14/01/2023.
//

import Foundation

class RequestManager {
    
    func fetch<T>(for endpoint: Endpoint) async throws -> T where T: Decodable {
        try await URLSession.shared.data(usingEndpointFor: endpoint)
    }
}
