//
//  URLSession+CryptoList.swift
//  CryptoList
//
//  Created by KC Okolo on 14/01/2023.
//

import Foundation

extension URLSession {
    
    func data(from url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                }
            }.resume()
        }
    }
    
    func data<T>(usingEndpointFor endpoint: Endpoint) async throws -> T where T: Decodable {
        let data = try await data(from: endpoint.url)
        return try JSONDecoder().decode(endpoint.type, from: data) as! T
    }
}
