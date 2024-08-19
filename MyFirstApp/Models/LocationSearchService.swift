//
//  LocationSearchService.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/19/24.
//

import Foundation
import MapKit

@Observable
class LocationSearchService: NSObject {
    var query: String = "" {
        didSet {
            self.handleSearchFragment(self.query)
        }
    }
    
    var results: [LocationResult] = []
    var status: SearchStatus = .idle
    var completer: MKLocalSearchCompleter
    
    init(filter: MKPointOfInterestFilter = .excludingAll, region: MKCoordinateRegion = MKCoordinateRegion(.world), types: MKLocalSearchCompleter.ResultType = [.pointOfInterest, .query, .address]) {
        self.completer = MKLocalSearchCompleter()
        super.init()
        
        self.completer.delegate = self
        self.completer.pointOfInterestFilter = filter
        self.completer.region = region
        self.completer.resultTypes = types
    }
    
    func handleSearchFragment(_ fragment: String) {
        self.status = .searching
        
        if !fragment.isEmpty {
            self.completer.queryFragment = fragment
        } else {
            self.status = .idle
            self.results = []
        }
    }
}

extension LocationSearchService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results.map { result in
            LocationResult(title: result.title, subtitle: result.subtitle)
        }
        
        self.status = .result
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}

// Hasable- A type that can be hashed into a Hasher to produce an integer hash value.
// Identifiable- A class of types whose instances hold the value of an entity with stable identity.
struct LocationResult: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
}

enum SearchStatus: Equatable { // A type that can be compared for value equality.
    case idle
    case searching
    case error(String)
    case result
}
