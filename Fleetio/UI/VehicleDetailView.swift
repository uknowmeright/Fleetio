//
//  VehicleDetailView.swift
//  Fleetio
//
//  Created by Paul Lehn on 9/7/25.
//

import SwiftUI


struct VehicleDetailView: View {
    
    var vehicle: Vehicle
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: vehicle.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                            ProgressView()
                        }
                        .frame(height: 200)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(12)
                            .shadow(radius: 4)
                        
                    case .failure:
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                            Image(systemName: "car.fill")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                        .frame(height: 200)
                        
                    @unknown default:
                        EmptyView()
                            .frame(height: 200)
                    }
                }
                VStack(alignment: .leading, spacing: 12) {
                    Label {
                        Text(vehicle.vehicle_status_name)
                            .font(.headline)
                            .foregroundStyle(vehicle.vehicleStatus.color)
                    } icon: {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(vehicle.vehicleStatus.color)
                    }
                    Divider()
                    infoRow(label: "Type", value: vehicle.vehicle_type_name)
                    infoRow(label: "VIN", value: vehicle.vin ?? "Unknown")
                    infoRow(label: "License Plate", value: vehicle.license_plate ?? "Unknown")
                    infoRow(label: "Make/Model", value: vehicle.makeModel)
                    infoRow(label: "Meter (Primary)", value: vehicle.primaryMeterString)
                    infoRow(label: "Meter (Secondary)", value: vehicle.secondaryMeterString)
                    infoRow(label: "Driver", value: vehicle.driver?.info ?? "Unknown")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
                .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle(vehicle.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text("\(label):")
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

//#Preview {
//    VehicleDetailView(
//        vehicle: .init(
//            id: 1,
//            name: "Test",
//            make: "Test",
//            model: "Test",
//            year: 2020,
//            vehicle_type_name: "Test",
//            vehicle_status_name: "Test"
//        )
//    )
//}
