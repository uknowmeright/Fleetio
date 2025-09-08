//
//  ContentViewModel.swift
//  Fleetio
//
//  Created by Paul Lehn on 9/7/25.
//

import Foundation

extension ContentView {
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var vehicles: [Vehicle] = []
        @Published var isLoading = false
        @Published var searchText: String = ""
        @Published var selectedVehicle: Vehicle?
        
        private var apiClient: FleetioAPIClient
        private var nextCursor: String? = nil
        private var isFetchingMore = false
        
        init(
            apiClient: FleetioAPIClient = ProdFleetioAPIClient()
        ) {
            self.apiClient = apiClient
            
            Task {
                await self.fetchVehicles()
            }
        }
        
        func fetchVehicles(reset: Bool = true) async {
            guard let _ = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return
            }
            
            if isLoading { return }
            isLoading = true

            do {
                let response = try await apiClient.fetchVehicles(for: searchText, cursor: reset ? nil : nextCursor)
                if reset {
                    vehicles = response.records
                } else {
                    vehicles.append(contentsOf: response.records)
                }
                nextCursor = response.next_cursor
            } catch {
                print(error.localizedDescription)
            }
            isLoading = false
        }
        
        func fetchNextPageIfNeeded(current vehicle: Vehicle) async {
            guard let last = vehicles.last else { return }
            guard last.id == vehicle.id else { return }
            guard let _ = nextCursor, !isFetchingMore else { return }
            
            isFetchingMore = true
            await fetchVehicles(reset: false)
            isFetchingMore = false
        }
    }
}
