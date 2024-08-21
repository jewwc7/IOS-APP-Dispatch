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
    @Binding var addresses: [LocationResult]
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

                region = response.boundingRegion
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
}

// #Preview {
//    MapView()
// }
