//
//  MapView.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/20/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Binding var address: LocationResult
    @State var region = MKCoordinateRegion()
    @State private(set) var annotationItems: [AnnotationItem] = []

    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: annotationItems,
            annotationContent: { item in
                MapMarker(coordinate: item.coordinate)
            }
        )
        .onAppear {
            // print("address", address)
            getPlace(from: address)
        }.onChange(of: address) { _, _ in  // _, _ oldvalue, newValue
            print("onChange address", address)
            getPlace(from: address)
        }
        .edgesIgnoringSafeArea(.bottom)
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
                annotationItems = response.mapItems.map {
                    AnnotationItem(
                        latitude: $0.placemark.coordinate.latitude,
                        longitude: $0.placemark.coordinate.longitude
                    )
                }

                region = response.boundingRegion
            }
        }
    }
}

// #Preview {
//    MapView()
// }
