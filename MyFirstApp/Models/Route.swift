//
//  Route.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/31/24.
//

import Foundation

//
//  Customer.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/25/24.
//

import CoreData
import Foundation
import MapKit
import SwiftData

// NSObject, NSFetchRequestResult, Identifiable

enum RouteStatus {
    case active
    case inactive
}

// when adding a new one I need to add default values
// these are run in migrations,
// will get error if default values missing https://forums.developer.apple.com/forums/thread/746577
// Not in use
@Model
class Route: BaseModel {
    // Properties
    var id: String?
//    var orders: [Order]
    var status: String? // RouteStatus
    var driver: Driver?
    var orders = [Order]()
    var startDate = Date()
    var createdAt: Date
    var updatedAt: Date
    var polylines: [String: [[String: Double]]] = [:]

    // Initializer
    init(
        orders: [Order] = [],
        startDate: Date = Date(),
        driver: Driver? = nil

    ) {
        self.id = UUID().uuidString
        self.orders = []
        self.driver = driver
        self.status = "Inactive" // RouteStatus.inactive
        self.startDate = startDate
        self.polylines = [:]
        self.createdAt = .now
        self.updatedAt = .now
        self.orders = orders // make sure that the replationships are last in the init, so I don't get reandom errors
    }

    func addOrder(order: Order) {
        self.orders.append(order)
        do {
            try self.modelContext?.save()
        } catch {
            print("Couldnt add order to route \(String(describing: self.id))", error)
        }
    }

    func removeOrder(_ order: Order) {
        self.orders.removeAll { $0.id == order.id }
        if self.orders.count == 0 {
            self.driver = nil
        }
    }

    // PersistentIdentifier because of the id, UUID
    func createRoute() -> [PersistentIdentifier: [String: Stop]] {
        let routeDictionary = self.orders.reduce(into: [PersistentIdentifier: [String: Stop]]()) { result, order in
            result[order.id] = [ // this is like an object in js, in swift it's a dictionary
                "pickup": order.pickup,
                "dropoff": order.dropoff
            ]
        }
        return routeDictionary
    }

    func appendPolyline(_ polyline: MKPolyline, stop: Stop) {
        if self.containsMatchingStopId(stop: stop) {
            return
        }
        let coordinates = polyline.coordinates()
        self.polylines = [
            stop.id: coordinates.map { ["latitude": $0.latitude, "longitude": $0.longitude] }
        ]
    }

    // pull out the values from each object key, results in a 2D dictionary/array,
    // flatmap makes into on dictionary/array and the closure just tells it what to put into the array, the stops in this case

    func makeStops() -> [Stop] {
        return self.createRoute().values.flatMap { $0.values }.sorted { $0.dueAt < $1.dueAt }
    }

    func incompleteStops() -> [Stop] {
        return self.makeStops().filter { $0.deliveredAt == nil }
    }

    func nextStop() -> Stop? {
        return self.incompleteStops().first
    }

    func isCompletedRoute() -> Bool {
        return self.incompleteStops().count == 0
    }

    private func containsMatchingStopId(stop: Stop) -> Bool {
        return self.polylines.keys.contains(stop.id)
    }
}
