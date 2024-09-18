//
//  RouteViewModel.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/16/24.
//

import Foundation
import MapKit
import SwiftUI

struct StopWithMapMarkers: Identifiable {
    var id = UUID().uuidString
    var stop: Stop
    var mapMarker: MKMapItem
}

class RouteVM {
    @State var locationSearchService = LocationSearchService()

    func createCLLocationCoordinate(from route: Route) -> [CLLocationCoordinate2D] {
        let coordinates: [CLLocationCoordinate2D] = route.polylines.flatMap { dict in
            dict.value.compactMap { coordinateDict in
                if let lat = coordinateDict["latitude"], let lon = coordinateDict["longitude"] {
                    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
                }
                return nil
            }
        }
        return coordinates
    }

    func fetchMapMarkers(for stops: [Stop]) async -> [StopWithMapMarkers] {
        Logger.log(.action, "Fetching markers")
        var mapMarkers: [StopWithMapMarkers] = []

        for stop in stops {
            do {
                let response = try await locationSearchService.getPlace(from: self.createType(stop: stop))
                let marker = self.locationSearchService.createMapMarker(from: response)
                mapMarkers.append(StopWithMapMarkers(stop: stop, mapMarker: marker))
            } catch {
                Logger.log(.info, "Stop \(stop) MKLocalSearch reqyest failed ")
            }
        }

        Logger.log(.success, "Fetching markers completed")
        return mapMarkers
    }

    func fetchRoute(source: CLLocationCoordinate2D, destinationStop: Stop) async -> MKRoute? {
        Logger.log(.action, "Fetching route")
        do {
            let request = MKDirections.Request()

            let sourcePlacemark = MKPlacemark(coordinate: source)
            let routeSource = MKMapItem(placemark: sourcePlacemark)
            request.source = routeSource

            let secondStopPlace = try await locationSearchService.getPlace(from: self.createType(stop: destinationStop))
            if let destinationItem = secondStopPlace.mapItems.first {
                let destinationPlacemark = MKPlacemark(coordinate: destinationItem.placemark.coordinate)
                let routeDestination = MKMapItem(placemark: destinationPlacemark)
                routeDestination.name = destinationStop.address
                request.destination = routeDestination
                destinationItem.name = destinationStop.stopType
            }

            let directions = MKDirections(request: request)
            let calulatedDirections = try? await directions.calculate()
            if let calulatedRoute = calulatedDirections?.routes.first {
                Logger.log(.success, "Fetching route completed \(String(describing: calulatedRoute.polyline))")
                return calulatedRoute
            } else {
                return nil
            }

        } catch {
            Logger.log(.error, "error fetching route \(error) ")
        }
        return nil
    }

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
