//
//  FleetioTests.swift
//  FleetioTests
//
//  Created by Paul Lehn on 9/7/25.
//

import XCTest
@testable import Fleetio

class MockFleetioAPIClient: FleetioAPIClient {
    var response: VehicleResponse
    var shouldThrow = false
    
    init(response: VehicleResponse) {
        self.response = response
    }
    
    func fetchVehicles(for query: String, cursor: String?) async throws -> VehicleResponse {
        if shouldThrow {
            throw URLError(.badServerResponse)
        }
        return response
    }
}

final class FleetioTests: XCTestCase {

    @MainActor
    func testFetchVehiclesSuccess() async {
        let vehicle = Vehicle(
            id: 1,
            name: "Truck 1",
            make: "Ford",
            model: "F150",
            year: 2020,
            license_plate: "ABC123",
            vin: "1FTFW1E5XJFA12345",
            vehicle_type_name: "Truck",
            vehicle_status_name: "Active",
            default_image_url_small: nil,
            primary_meter_unit: "mi",
            primary_meter_value: "1200",
            primary_meter_date: "2025-01-01",
            secondary_meter_unit: nil,
            secondary_meter_value: nil,
            secondary_meter_date: nil,
            driver: nil
        )
        
        let response = VehicleResponse(
            start_cursor: "start",
            next_cursor: nil,
            per_page: 1,
            records: [vehicle]
        )
        
        let mockClient = MockFleetioAPIClient(response: response)
        let viewModel = ContentView.ViewModel(apiClient: mockClient)
        await viewModel.fetchVehicles()

        XCTAssertEqual(viewModel.vehicles.count, 1)
        XCTAssertEqual(viewModel.vehicles.first?.name, "Truck 1")
        XCTAssertEqual(viewModel.isLoading, false)
    }
    
    @MainActor
    func testFetchVehiclesFailure() async {
        let mockClient = MockFleetioAPIClient(response: VehicleResponse(start_cursor: "", next_cursor: nil, per_page: 0, records: []))
        mockClient.shouldThrow = true
        let viewModel = ContentView.ViewModel(apiClient: mockClient)
        await viewModel.fetchVehicles()
        
        XCTAssertEqual(viewModel.vehicles.count, 0)
        XCTAssertEqual(viewModel.isLoading, false)
    }
    
}
