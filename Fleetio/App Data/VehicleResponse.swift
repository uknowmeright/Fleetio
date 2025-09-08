//
//  VehicleResponse.swift
//  Fleetio
//
//  Created by Paul Lehn on 9/7/25.
//

struct VehicleResponse: Codable {
    let start_cursor: String
    let next_cursor: String?
    let per_page: Int
    let records: [Vehicle]
}
