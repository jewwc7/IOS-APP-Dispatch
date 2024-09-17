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
    var previousRouteTaken: [CLLocationCoordinate2D]? // come back this will be wat's saved
    @Binding var route: MKRoute?
    @Binding var shouldShowRoute: Bool
    @Binding var routeDestination: MKMapItem?
    @Binding var mapMarkers: [MKMapItem]

    init(route: Binding<MKRoute?>, shouldShowRoute: Binding<Bool>, routeDestination: Binding<MKMapItem?>, mapMarkers: Binding<[MKMapItem]>, previousRouteTaken: [CLLocationCoordinate2D]? = nil) {
        self._route = route
        self._shouldShowRoute = shouldShowRoute
        self._routeDestination = routeDestination
        self._mapMarkers = mapMarkers
        self.previousRouteTaken = previousRouteTaken
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
            if let previousRouteTaken = previousRouteTaken {
                MapPolyline(coordinates: previousRouteTaken)
                    .stroke(.orange, lineWidth: 6)
            }
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
            //   updateCameraPosition()
        }.onChange(of: shouldShowRoute) {
            if shouldShowRoute {
                withAnimation {
                    if let rect = route?.polyline.boundingMapRect {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }

        .edgesIgnoringSafeArea(.bottom)
        .frame(height: 400)
        //        .task(id: transportType) {
        //            await fetchRoute()
        //        }
    }

//    func updateCameraPosition() {
//        if let userLocation = locationManager.userLocation {
//            let userRegion = MKCoordinateRegion(
//                center: userLocation,
//                span: MKCoordinateSpan(
//                    latitudeDelta: 0.15,
//                    longitudeDelta: 0.15
//                )
//            )
//            withAnimation {
//                cameraPosition = .region(userRegion)
//            }
//        }
//    }
}

// #Preview {
//    MapViewWithRoute()
// }
