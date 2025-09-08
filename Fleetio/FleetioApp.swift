//
//  FleetioApp.swift
//  Fleetio
//
//  Created by Paul Lehn on 9/7/25.
//

import SwiftUI

@main
struct FleetioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
        }
    }
}
