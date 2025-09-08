//
//  ContentView.swift
//  Fleetio
//
//  Created by Paul Lehn on 9/7/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.vehicles) { vehicle in
                    HStack(spacing: 12) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(vehicle.vehicleStatus.color)
                        AsyncImage(url: vehicle.imageURL) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.2))
                                    ProgressView()
                                }
                                .frame(width: 70, height: 70)
                                
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipped()
                                    .cornerRadius(8)
                                
                            case .failure:
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.2))
                                    Image(systemName: "car.fill")
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 70, height: 70)
                                
                            @unknown default:
                                EmptyView()
                                    .frame(width: 70, height: 70)
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(vehicle.name)
                                .font(.headline)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            HStack {
                                Text(vehicle.vehicle_type_name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(vehicle.makeModel)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectedVehicle = vehicle
                    }
                    .task {
                        await viewModel.fetchNextPageIfNeeded(current: vehicle)
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                Task { await viewModel.fetchVehicles() }
            }
            .searchable(text: $viewModel.searchText)
            .onSubmit(of: .search) {
                Task { await viewModel.fetchVehicles() }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading Vehicles...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
            }
            .navigationTitle("Vehicles")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $viewModel.selectedVehicle) { vehicle in
                VehicleDetailView(vehicle: vehicle)
            }
        }
    }
}

#Preview {
    ContentView(viewModel: .init())
}
