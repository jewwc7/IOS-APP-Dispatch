//
//  MapView.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/20/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    //  @Binding var address: LocationResult
    var addresses: [LocationResult]
    @State var region = MKCoordinateRegion()
    @State private(set) var annotationItems: [AnnotationItem] = []

    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: annotationItems,
            annotationContent: { item in
                MapMarker(coordinate: item.coordinate) // default marker
                // custom markers, they're tough to see though
//                MapAnnotation(coordinate: item.coordinate) {
//                    // Custom view for marker
//                    Image(systemName: "shippingbox")
//                        .aspectRatio(contentMode: .fit) // Keeps the aspect ratio of the image
//                        .frame(width: 100, height: 100) // Specify the desired width and height
//                        // .foregroundColor(.blue)
//                        .onTapGesture {
//                            // TODO: display info about the marker
//                        }
//                }
            }
        )
        .onAppear {
            // print("address", address)
            //  getPlace(from: addresses.first)
        }.onChange(of: addresses) { _, _ in // _, _ oldvalue, newValue
            //   print("onChange address", addresses)
            for address in addresses {
                getPlace(from: address)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(height: 400)
    }

    func getPlace(from address: LocationResult) {
        let request = MKLocalSearch.Request()
        let title = address.title
        let subTitle = address.subtitle

        request.naturalLanguageQuery = subTitle.contains(title)
            ? subTitle : title + ", " + subTitle

        Task {
            let response = try await MKLocalSearch(request: request).start()
            await MainActor.run {
                addAnnotationItems(response)
                updateRegionToFitAllAnnotations()
            }
        }
    }

    func addAnnotationItems(_ response: MKLocalSearch.Response) {
        let newAnnotation: [AnnotationItem] = response.mapItems.map {
            AnnotationItem(
                latitude: $0.placemark.coordinate.latitude,
                longitude: $0.placemark.coordinate.longitude
            )
        }
        // TODO: bug where all entered addresses will appear on map. COme back later and filter out based on tpye(pu or droppff, would need to add a new struct that like Locationtype
        // print(annotationItems.count)

        if let firstAn = newAnnotation.first {
            annotationItems.append(firstAn)
        }
    }

    // zoom map out to see both addresses
    func updateRegionToFitAllAnnotations() {
        guard !annotationItems.isEmpty else { return }

        var minLat = annotationItems[0].coordinate.latitude
        var maxLat = annotationItems[0].coordinate.latitude
        var minLon = annotationItems[0].coordinate.longitude
        var maxLon = annotationItems[0].coordinate.longitude

        for annotation in annotationItems {
            minLat = min(minLat, annotation.coordinate.latitude)
            maxLat = max(maxLat, annotation.coordinate.latitude)
            minLon = min(minLon, annotation.coordinate.longitude)
            maxLon = max(maxLon, annotation.coordinate.longitude)
        }

        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let spanLat = (maxLat - minLat) * 1.2 // Add some padding
        let spanLon = (maxLon - minLon) * 1.2 // Add some padding

        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon)
        )
    }
}

// #Preview {
//    MapView()
// }
