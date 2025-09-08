//
//  Untitled.swift
//  Fleetio
//
//  Created by Paul Lehn on 9/7/25.
//

import SwiftUICore

struct Vehicle: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let make: String?
    let model: String?
    let year: Int?
    let license_plate: String?
    let vin: String?
    let vehicle_type_name: String
    let vehicle_status_name: String
    let default_image_url_small: String?
    let primary_meter_unit: String?
    let primary_meter_value: String?
    let primary_meter_date: String?
    let secondary_meter_unit: String?
    let secondary_meter_value: String?
    let secondary_meter_date: String?
    let driver: Driver?
    
    var imageURL: URL? {
        guard let urlString = default_image_url_small else { return nil }
        return URL(string: urlString)
    }
    
    var primaryMeterString: String {
        guard
            let unit = primary_meter_unit,
            let value = primary_meter_value,
            let date = primary_meter_date
        else {
            return ""
        }
        return "\(unit) \(value) - \(date)"
    }

    var secondaryMeterString: String {
        guard
            let unit = secondary_meter_unit,
            let value = secondary_meter_value,
            let date = secondary_meter_date
        else {
            return ""
        }
        return "\(unit) \(value) - \(date)"
    }
    
    var makeModel: String {
        guard make != nil || model != nil else { return "" }
        return (make ?? "") + " - " + (model ?? "")
    }
    
    var vehicleStatus: VehicleStatus {
        VehicleStatus(rawValue: vehicle_status_name) ?? .unknown
    }
}

enum VehicleStatus: String {
    case Active, Inacitve, In_Shop, Out_of_Service, unknown
    
    var color: Color {
        switch self {
        case .Active:
            Color.green
        case .Inacitve:
            Color.blue
        case .In_Shop:
            Color.orange
        case .Out_of_Service:
            Color.red
        case .unknown:
            Color.gray
        }
    }
}

