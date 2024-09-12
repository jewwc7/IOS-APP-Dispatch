//
//  MapViewWithRoute.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/10/24.
//

import MapKit
import SwiftData
import SwiftUI

// Where I left, How can I add markers to all the stops?
// Don't think it's possible to add more than 2 places(source and destination)
// In order to do that I belive I need to use corrdinates in the like https://stackoverflow.com/questions/77526711/swiftui-map-mappolyline-not-showing
// maybe I should save the coordinates in the models when created? Or I can just get the coordinates? --getPlace line 65 in fetch ROute
struct MapViewWithRoute: View {
    @State var region = MKCoordinateRegion()

//    @Query private var listPlacemarks: [MKPlacemark]

    // haven;t requested the user location, will see warning in console
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    // Route
    @Binding var shouldShowRoute: Bool
    @Binding var routeDestination: MKMapItem?
    @Binding var route: MKRoute?
    @Binding var annotationItems: [MKMapItem]

    var body: some View {
        Map(position: $cameraPosition) { // selection: $selectedPlacemark
            UserAnnotation()
            ForEach(annotationItems, id: \.self) { item in
                Group {
                    Marker(coordinate: item.placemark.coordinate) {
                        Label("Placemarker", systemImage: "star")
                    }
                    .tint(.yellow)
                } // .tag(placemark)
            }
            if let route, shouldShowRoute {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
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

        .edgesIgnoringSafeArea(.bottom)
        .frame(height: 400)
        //        .task(id: transportType) {
        //            await fetchRoute()
        //        }
    }
//
//    func addAnnotationItems(_ response: MKLocalSearch.Response) {
//        let newAnnotation: [AnnotationItem] = response.mapItems.map {
//            AnnotationItem(
//                latitude: $0.placemark.coordinate.latitude,
//                longitude: $0.placemark.coordinate.longitude
//            )
//        }
//        // TODO: bug where all entered addresses will appear on map. COme back later and filter out based on tpye(pu or droppff, would need to add a new struct that like Locationtype
//        // print(annotationItems.count)
//
//        if let firstAn = newAnnotation.first {
//            annotationItems.append(firstAn)
//        }
//    }
//
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
//    MapView()
// }

// #Preview {
//    MapViewWithRoute()
// }
