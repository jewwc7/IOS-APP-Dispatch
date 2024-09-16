//
//  RouteViewModel.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/16/24.
//

import Foundation
import MapKit
import SwiftUI

class RouteVM {
    var route: Route
    @State var locationSearchService = LocationSearchService()

    init(_ route: Route) {
        self.route = route
    }

    func createCLLocationCoordinate() -> [CLLocationCoordinate2D] {
        let coordinates: [CLLocationCoordinate2D] = self.route.polylines.compactMap { dict in
            if let lat = dict["latitude"], let lon = dict["longitude"] {
                return CLLocationCoordinate2D(latitude: lat, longitude: lon)
            }
            return nil
        }
        return coordinates
    }

    func fetchMapMarkers() async -> [MKMapItem] {
        Logger.log(.action, "Fetching markers")
        var mapMarkers: [MKMapItem] = []

        let stops = self.route.makeStops() // include this in the if statement
        for stop in stops {
            do {
                let response = try await locationSearchService.getPlace(from: self.createType(stop: stop))
                let marker = self.locationSearchService.createMapMarker(from: response)
                mapMarkers.append(marker)
            } catch {
                Logger.log(.info, "Stop \(stop) MKLocalSearch reqyest failed ")
            }
        }

        Logger.log(.success, "Fetching markers completed")
        return mapMarkers
    }

//    func fetchRoute() async {
//        Logger.log(.action, "Fetching route")
//        do {
//                let firstStop = route?.makeStops().first
//                let lastStop = route.makeStops().first
//                let request = MKDirections.Request()
//                let place = try await locationSearchService.getPlace(from: createType(stop: firstStop!))
//                let secondStopPlace = try await locationSearchService.getPlace(from: createType(stop: lastStop!))
//                if let sourceMapItem = place.mapItems.first {
//                    let sourcePlacemark = MKPlacemark(coordinate: sourceMapItem.placemark.coordinate)
//                    let routeSource = MKMapItem(placemark: sourcePlacemark)
//                    request.source = routeSource
//                    sourceMapItem.name = "pickup"
//                }
//                if let destinationItem = secondStopPlace.mapItems.first {
//                    let destinationPlacemark = MKPlacemark(coordinate: destinationItem.placemark.coordinate)
//                    let routeDestination = MKMapItem(placemark: destinationPlacemark)
//                    routeDestination.name = lastStop?.address
//                    request.destination = routeDestination
//
//                    destinationItem.name = "dropoff"
//                }
//
//                let directions = MKDirections(request: request)
//                let calulatedDirections = try? await directions.calculate()
//                if let calulatedRoute = calulatedDirections?.routes.first {
//               //     route = calulatedRoute
//               //     travelInterval = calulatedRoute.expectedTravelTime
//                //    firstRoute?.appendPolyline(calulatedRoute.polyline)
//               //     try firstRoute?.modelContext?.save()
//                }
//
//            Logger.log(.success, "Fetching route completed \(String(describing: route?.polyline))")
//
//        } catch {
//            Logger.log(.error, "error fetching route \(error) ")
//        }
//    }

    func createType(stop: Stop) -> LocationResult {
        return LocationResult(id: stop.locationId, title: stop.address, subtitle: stop.cityStateZip)
    }
}

extension MKPolyline {
    func coordinates() -> [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: self.pointCount)
        self.getCoordinates(&coords, range: NSRange(location: 0, length: self.pointCount))
        return coords
    }
}

let fileUrl = "routePolyline.json"

// not in use but the MKPOlyline protion may come in handy
func fetchAndDesearilze() {
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = documentsDirectory.appendingPathComponent(fileUrl)

        do {
            let data = try Data(contentsOf: fileURL)
            if let coordinateArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Double]] {
                // Convert JSON back to CLLocationCoordinate2D array
                let coordinates = coordinateArray.map { CLLocationCoordinate2D(latitude: $0["latitude"]!, longitude: $0["longitude"]!) }

                // Create MKPolyline from the coordinates
                let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)

                // Now you can use this polyline, for example, adding it to a map
                // mapView.addOverlay(polyline)
            }
        } catch {
            print("Failed to load polyline: \(error)")
        }
    }
}
