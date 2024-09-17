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
// Pretty sure the previousRoute works, but I need to only appendPolyline if not already appeneded
// how can I do that? MAybe make another model that houses these and the stops just like I did before, that way ifI already have one for the stop, don't save again.
// THen also should change the route when stops are completed
// first need to make destination the first not compelted stop.incomplete_stops
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
    @State private(set) var mapMarkers: [MKMapItem] = []
    @State private var selectedRoute: Route?
    
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
                        Task {
                            if selectedRoute?.id == firstRoute.id {
                                shouldShowRoute = false
                                mkRoute = nil
                                await fetchRoute(for: selectedRoute)
                                await fetchMapMarkers(for: selectedRoute)
                            }
                        }
                    }
                    if let selectedRoute = selectedRoute {
                        if selectedRoute.id == firstRoute.id {
                            MapViewWithRoute(route: $mkRoute, shouldShowRoute: $shouldShowRoute, routeDestination: $routeDestination, mapMarkers: $mapMarkers, previousRouteTaken: createCLLocationCoordinate(for: selectedRoute))
                            Button("Toggle show route") {
                                shouldShowRoute.toggle()
                            }
                            RouteList(route: selectedRoute, loggedInDriver: loggedInDriver)
                        } else {
                            RouteList(route: selectedRoute, loggedInDriver: loggedInDriver)
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
        
    func fetchMapMarkers(for route: Route?) async {
        Logger.log(.action, "Fetching markers")

        if let route = route {
            let stops = route.makeStops() // include this in the if statement
            for stop in stops {
                do {
                    let response = try await locationSearchService.getPlace(from: createType(stop: stop))
                    let marker = locationSearchService.createMapMarker(from: response)
                    mapMarkers.append(marker)
                } catch {
                    Logger.log(.info, "Stop \(stop) MKLocalSearch reqyest failed ")
                }
            }
        } else {
            Logger.log(.warning, "route was undefined \(#function)")
        }
                
        Logger.log(.success, "Fetching markers completed")
    }
        
    func fetchRoute(for route: Route?) async {
        Logger.log(.action, "Fetching route")
        do {
            if let route = route {
                let firstStop = route.makeStops().first
                let request = MKDirections.Request()
                    
                let sourcePlacemark = MKPlacemark(coordinate: locationManager.userLocation!)
                let routeSource = MKMapItem(placemark: sourcePlacemark)
                request.source = routeSource
                    
                let secondStopPlace = try await locationSearchService.getPlace(from: createType(stop: firstStop!))
                if let destinationItem = secondStopPlace.mapItems.first {
                    let destinationPlacemark = MKPlacemark(coordinate: destinationItem.placemark.coordinate)
                    let routeDestination = MKMapItem(placemark: destinationPlacemark)
                    routeDestination.name = firstStop?.address
                    request.destination = routeDestination
                    destinationItem.name = firstStop?.stopType
                }
                    
                let directions = MKDirections(request: request)
                let calulatedDirections = try? await directions.calculate()
                if let calulatedRoute = calulatedDirections?.routes.first {
                    mkRoute = calulatedRoute
                    travelInterval = calulatedRoute.expectedTravelTime
                    route.appendPolyline(calulatedRoute.polyline)
                    try route.modelContext?.save()
                }
            } else {
                Logger.log(.warning, "route was undefined \(#function)")
            }
            Logger.log(.success, "Fetching route completed \(String(describing: mkRoute?.polyline))")
                
        } catch {
            Logger.log(.error, "error fetching route \(error) ")
        }
    }
        
    func createType(stop: Stop) -> LocationResult {
        return LocationResult(id: stop.locationId, title: stop.address, subtitle: stop.cityStateZip)
    }
    
    func createCLLocationCoordinate(for route: Route?) -> [CLLocationCoordinate2D] {
        if let route = route {
            let coordinates: [CLLocationCoordinate2D] = route.polylines.compactMap { dict in
                if let lat = dict["latitude"], let lon = dict["longitude"] {
                    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
                }
                return nil
            }
            return coordinates
        } else {
            return [CLLocationCoordinate2D(latitude:  1.1, longitude:  1.1)] // Comeback
        }
    }
}

// #Preview {
//    RouteScreen().modelContainer(for: [Order.self, Customer.self, Driver.self], inMemory: true).environmentObject(AppStateManager())
// }
