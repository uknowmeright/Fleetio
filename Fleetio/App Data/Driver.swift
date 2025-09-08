//
//  Driver.swift
//  Fleetio
//
//  Created by Paul Lehn on 9/8/25.
//

struct Driver: Codable, Identifiable, Hashable {
    let id: Int?
    let name: String?
    let email: String?
    let employee: Bool?
    let employee_number: String?
    let group_id: Int?
    let default_image_url: String?
    
    var info: String {
        guard
            let id = id,
            let name = name,
            let email = email
        else {
            return ""
        }
        return "\(id) - \(name) (\(email))"
    }
}
