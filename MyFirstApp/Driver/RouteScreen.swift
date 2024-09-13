//
//  DriverOrderScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

import MapKit
import SwiftData
import SwiftUI

struct RouteScreen: View {
    @Environment(\.modelContext) private var context // how to CRUD state
    @EnvironmentObject var appState: AppStateManager

    @State var locationSearchService = LocationSearchService()
    @State private var selectedPlacemark: MKPlacemark?
    private var locationManager = LocationManager()
    // Route
    @State var shouldShowRoute: Bool = false
    @State private var routeDisplaying: Bool = false // don't kow if I need this for my use case, it's to clear the route if you want.
    @State private var route: MKRoute?
    @State private var travelInterval: TimeInterval?
    @State private var routeDestination: MKMapItem?
    @State private(set) var mapMarkers: [MKMapItem] = []

    var body: some View {
        ScrollView {
            if let loggedInDriver = appState.loggedInDriver {
                if loggedInDriver.routes.count == 0 {
                    ContentUnavailableView("No Routes", systemImage: "truck.box")
                }
                MapViewWithRoute(shouldShowRoute: $shouldShowRoute, routeDestination: $routeDestination, route: $route, mapMarkers: $mapMarkers).task {
                    if true { // selectedPlacemark != nil //look at video and see what this is
                        routeDisplaying = false
                        shouldShowRoute = false
                        route = nil
                        await fetchRoute()
                        await fetchMapMarkers()
                    }
                }
                Button("Toggle show route") {
                    shouldShowRoute.toggle()
                }
                ForEach(loggedInDriver.sortRoutes()) { route in
                    Section(header: Text(convertDateToDateOnlyString(day: route.startDate)).bold().font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)) {
                        ForEach(route.makeStops(), id: \.id) { stop in
                            DriverStopCard(stop: stop, driver: loggedInDriver)
                        }
                    }
                }
            } else {
                Text("Driver not logged in")
            }
        }
    }

    func fetchMapMarkers() async {
        Logger.log(.action, "Fetching markers")
        if let loggedInDriver = appState.loggedInDriver {
            let firstRoute = loggedInDriver.sortRoutes().first
            let stops = firstRoute!.makeStops() // include this in the if statement
            for stop in stops {
                do {
                    let response = try await locationSearchService.getPlace(from: createType(stop: stop))
                    let marker = locationSearchService.createMapMarker(from: response)
                    mapMarkers.append(marker)
                } catch {
                    Logger.log(.info, "Stop \(stop) MKLocalSearch reqyest failed ")
                }
            }
            Logger.log(.success, "Fetching markers completed")
        }
    }

    func fetchRoute() async {
        Logger.log(.action, "Fetching route")
        do {
            if let loggedInDriver = appState.loggedInDriver {
                let firstRoute = loggedInDriver.sortRoutes().first
                let firstStop = firstRoute?.makeStops().first
                let lastStop = firstRoute?.makeStops().last
                let request = MKDirections.Request()
                let place = try await locationSearchService.getPlace(from: createType(stop: firstStop!))
                let secondStopPlace = try await locationSearchService.getPlace(from: createType(stop: lastStop!))
                if let sourceMapItem = place.mapItems.first {
                    let sourcePlacemark = MKPlacemark(coordinate: sourceMapItem.placemark.coordinate)
                    let routeSource = MKMapItem(placemark: sourcePlacemark)
                    request.source = routeSource

                    sourceMapItem.name = "pickup"
                }
                if let destinationItem = secondStopPlace.mapItems.first {
                    let destinationPlacemark = MKPlacemark(coordinate: destinationItem.placemark.coordinate)
                    let routeDestination = MKMapItem(placemark: destinationPlacemark)
                    routeDestination.name = lastStop?.address
                    request.destination = routeDestination

                    destinationItem.name = "dropoff"
                }

                let directions = MKDirections(request: request)
                let result = try? await directions.calculate()
                route = result?.routes.first
                travelInterval = route?.expectedTravelTime
            }
            Logger.log(.success, "Fetching route completed \(String(describing: route?.polyline))")
        } catch {
            Logger.log(.error, "error fetching route \(error) ")
        }
    }

    func createType(stop: Stop) -> LocationResult {
        return LocationResult(id: stop.locationId, title: stop.address, subtitle: stop.cityStateZip)
    }
}

// #Preview {
//    RouteScreen().modelContainer(for: [Order.self, Customer.self, Driver.self], inMemory: true).environmentObject(AppStateManager())
// }
