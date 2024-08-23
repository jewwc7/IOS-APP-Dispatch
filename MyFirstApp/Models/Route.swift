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
class Route {
    // Properties
    var id: String?
//    var orders: [Order]
    var status: String? // RouteStatus
    var driver: Driver?
    var orders = [Order]()
    var startDate = Date()

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
        self.orders = orders
        self.startDate = startDate
    }

    func addOrder(order: Order) {
        self.orders.append(order)
        do {
            try self.modelContext?.save()
        } catch {
            print("Couldnt add order to route \(self.id)", error)
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

    // pull out the values from each object key, results in a 2D dictionary/array,
    // flatmap makes into on dictionary/array and the closure just tells it what to put into the array, the stops in this case

    func makeStops() -> [Stop] {
        return self.createRoute().values.flatMap { $0.values }
    }
}
