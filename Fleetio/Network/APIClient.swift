//
//  APIClient.swift
//  Fleetio
//
//  Created by Paul Lehn on 9/7/25.
//

import Foundation
import Combine

protocol FleetioAPIClient {
    func fetchVehicles(for query: String, cursor: String?) async throws -> VehicleResponse
}

class ProdFleetioAPIClient: FleetioAPIClient {
    
    let baseURLString = "https://secure.fleetio.com/api/v1/vehicles"
    
    func fetchVehicles(for query: String, cursor: String? = nil) async throws -> VehicleResponse {
        var urlString = baseURLString
        if !query.isEmpty {
            urlString += "?filter[name][like]=\(query)"
        }
        if let cursor = cursor {
            urlString.append("cursor=\(cursor)")
        }
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.addValue("Token 386153e0248e7533ffdbb34652e9ee3c43a63ba6", forHTTPHeaderField: "Authorization")
        request.addValue("c0276762e6", forHTTPHeaderField: "Account-Token")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(VehicleResponse.self, from: data)
    }
    
}
