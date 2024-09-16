//
//  MapViewWithRoute.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/10/24.
//

import MapKit
import SwiftData
import SwiftUI

struct MapViewWithRoute: View {
    @State var region = MKCoordinateRegion()
    @State private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    // Route
    var previousRouteTaken: Any? // come back this will be wat's saved
    @Binding var route: MKRoute?
    @Binding var shouldShowRoute: Bool
    @Binding var routeDestination: MKMapItem?
    @Binding var mapMarkers: [MKMapItem]

    init(route: Binding<MKRoute?>, shouldShowRoute: Binding<Bool>, routeDestination: Binding<MKMapItem?>, mapMarkers: Binding<[MKMapItem]>) {
        self._route = route
        self._shouldShowRoute = shouldShowRoute
        self._routeDestination = routeDestination
        self._mapMarkers = mapMarkers
    }

    var body: some View {
        Map(position: $cameraPosition) { // selection: $selectedPlacemark
            UserAnnotation()
            ForEach(mapMarkers, id: \.self) { item in
                Group {
                    Marker(coordinate: item.placemark.coordinate) {
                        Label(item.name ?? "", systemImage: "truck.box")
                    }
                    .tint(.orange)
                }.tag(item)
            }
            if let route, shouldShowRoute {
                MapPolyline(coordinates: route.polyline.coordinates())
                    .stroke(.blue, lineWidth: 6)
            }
            // I need to check for  route.createCLLocationCoordinate() not returning empty

            // if previousROuteTaken put the polyline
        }
        //        .onMapCameraChange { context in
        //            region = context.region
        //        }
        //        .onAppear {
        //            MapManager.removeSearchResults(modelContext)
        //            updateCameraPosition()
        //        }
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear {
            locationManager.locationManager.requestWhenInUseAuthorization()
        }

        .edgesIgnoringSafeArea(.bottom)
        .frame(height: 400)
        //        .task(id: transportType) {
        //            await fetchRoute()
        //        }
    }

    // zoom map out to see both addresses
//    func updateRegionToFitAllAnnotations() {
//        guard !annotationItems.isEmpty else { return }
//
//        var minLat = annotationItems[0].coordinate.latitude
//        var maxLat = annotationItems[0].coordinate.latitude
//        var minLon = annotationItems[0].coordinate.longitude
//        var maxLon = annotationItems[0].coordinate.longitude
//
//        for annotation in annotationItems {
//            minLat = min(minLat, annotation.coordinate.latitude)
//            maxLat = max(maxLat, annotation.coordinate.latitude)
//            minLon = min(minLon, annotation.coordinate.longitude)
//            maxLon = max(maxLon, annotation.coordinate.longitude)
//        }
//
//        let centerLat = (minLat + maxLat) / 2
//        let centerLon = (minLon + maxLon) / 2
//        let spanLat = (maxLat - minLat) * 1.2 // Add some padding
//        let spanLon = (maxLon - minLon) * 1.2 // Add some padding
//
//        region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
//            span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon)
//        )
//    }
}

// #Preview {
//    MapViewWithRoute()
// }
