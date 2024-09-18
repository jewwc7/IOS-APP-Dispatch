//
//  DriverOrderScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

import MapKit
import SwiftData
import SwiftUI

// Where I left
// Check that polyline is only appened if it was not before

struct RouteScreen: View {
    @Environment(\.modelContext) private var context // how to CRUD state
    @EnvironmentObject var appState: AppStateManager

    @State var locationSearchService = LocationSearchService()
    @State private var selectedPlacemark: MKPlacemark?
    private var locationManager = LocationManager()
    @State var routeVm = RouteVM()
    // Route
    @State var shouldShowRoute: Bool = false
    @State private var routeDisplaying: Bool = false // don't kow if I need this for my use case, it's to clear the route if you want.
    @State private var mkRoute: MKRoute?
    @State private var travelInterval: TimeInterval?
    @State private var routeDestination: MKMapItem?
    @State private(set) var stopWithMapMarkers: [StopWithMapMarkers] = []
    @State private var selectedRoute: Route?
    @State private var previousNextStop: Stop? // I passed this all the way down to driverCard, so I can update this when the stop deliveredAt is set

    var body: some View {
        ScrollView {
            if let loggedInDriver = appState.loggedInDriver {
                if let firstRoute = appState.loggedInDriver?.routes.first {
                    let soretedRouted = loggedInDriver.sortRoutes()
                    Picker("Select Route", selection: $selectedRoute) {
                        ForEach(soretedRouted, id: \.id) { route in
                            Text(convertDateToDateOnlyString(day: route.startDate)).tag(route as Route?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onAppear {
                        if selectedRoute == nil {
                            selectedRoute = firstRoute
                        }
                    }
                    .onChange(of: selectedRoute) { _, _ in
                        if let selectedRoute = selectedRoute, selectedRoute.id == firstRoute.id {
                            updateMap(for: selectedRoute)
                        }
                    }
                    .onChange(of: previousNextStop?.id) { _, _ in
                        if let selectedRoute = selectedRoute, selectedRoute.id == firstRoute.id {
                            updateMap(for: selectedRoute)
                        }
                    }
                    if let selectedRoute = selectedRoute {
                        if selectedRoute.id == firstRoute.id {
                            MapViewWithRoute(route: $mkRoute, shouldShowRoute: $shouldShowRoute, routeDestination: $routeDestination, stopWithMapMarkers: $stopWithMapMarkers, previousRouteTaken: previousRouteTaken(for: selectedRoute))
                            Button("Toggle show route") {
                                shouldShowRoute.toggle()
                            }
                            RouteList(route: selectedRoute, loggedInDriver: loggedInDriver, previousNextStop: $previousNextStop)
                        } else {
                            RouteList(route: selectedRoute, loggedInDriver: loggedInDriver, previousNextStop: $previousNextStop)
                        }
                    }

                } else {
                    ContentUnavailableView("No Routes", systemImage: "truck.box")
                }

            } else {
                ContentUnavailableView("Driver not logged in", systemImage: "xmark")
            }
        }
    }

    func updateMap(for route: Route) {
        Task {
            if let nextStop = route.nextStop() {
                shouldShowRoute = false
                mkRoute = nil
                await fetchMapMarkers(for: selectedRoute)
                let result = await fetchRoute(to: nextStop, route: selectedRoute)
                if result.result == .success {
                    shouldShowRoute = true
                }
            }
        }
    }

    func fetchMapMarkers(for route: Route?) async {
        if let route = route {
            let allMapMarkers = await routeVm.fetchMapMarkers(for: route.makeStops())
            stopWithMapMarkers = allMapMarkers
        }
    }

    func fetchRoute(to stop: Stop, route: Route?) async -> ResultWithMessage {
        Logger.log(.action, "Fetching route")
        if let route = route {
            do {
                let calulatedRoute = await routeVm.fetchRoute(source: locationManager.userLocation!, destinationStop: stop)
                if let calulatedRoute = calulatedRoute {
                    mkRoute = calulatedRoute
                    travelInterval = calulatedRoute.expectedTravelTime

                    route.appendPolyline(calulatedRoute.polyline, stop: stop)
                    try route.modelContext?.save()
                    return ResultWithMessage(result: .success, message: "")

                } else {
                    return ResultWithMessage(result: .noResult, message: "Route was unable to be calculated")
                }
            } catch {
                Logger.log(.error, "error when fetching route \(error.localizedDescription) ")
                return ResultWithMessage(result: .failure, message: "error when fetching route \(error.localizedDescription) ")
            }
        }
        return ResultWithMessage(result: .noResult, message: "Route was undefined")
    }

    func previousRouteTaken(for route: Route?) -> [CLLocationCoordinate2D] {
        if let route = route {
            let coordinates = routeVm.createCLLocationCoordinate(from: route)
            return coordinates
        } else {
            return []
        }
    }
}

// #Preview {
//    RouteScreen().modelContainer(for: [Order.self, Customer.self, Driver.self], inMemory: true).environmentObject(AppStateManager())
// }
