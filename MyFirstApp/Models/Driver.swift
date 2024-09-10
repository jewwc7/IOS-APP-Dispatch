//
//  Driver.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/1/24.
//

import CoreData
import Foundation
import SwiftData

// NSObject, NSFetchRequestResult, Identifiable

enum DriverOrderAction {
    case claim
    case release
}

// when adding a new one I need to add default values
// these are run in migrations,
// will get error if default values missing https://forums.developer.apple.com/forums/thread/746577
@Model
class Driver: BaseModel {
    // Properties
    var id: String?
    var name: String
    var orders = [Order]() // this and below are the same thing.
    var routes: [Route] = [] // if relation is an array you have to append,
    var createdAt: Date
    var updatedAt: Date
    var totalNumberOfOrders: Int {
        return self.orders.count
    }

    // Initializer
    init(
        name: String = ""

    ) {
        self.id = UUID().uuidString
        self.name = name
        self.createdAt = .now
        self.updatedAt = .now
    }

    func handleOrderAction(action: DriverOrderAction, order: Order) {
        print(action, "performed")
        switch action {
        case DriverOrderAction.claim:
            self.claimOrder(order: order)
        case DriverOrderAction.release:
            return
        }
    }

    private func claimOrder(order: Order) {
        Logger.log(.action, "\(self.name) requested to claim an order")

        let response = order.claim(driver: self)
        if response.result == .success {
            order.driver = self
            let route = self.addOrderToRoute(order: order)
            if route.isNew {
                self.routes.append(route.route)
            }
        }
    }

    func numberOfOrders() -> Int {
        return self.routes.reduce(0) { result, route -> Int in
            return result + route.orders.count
        }
    }

    private func addOrderToRoute(order: Order) -> AddOrderToRoute {
        if let routeForOrder = self.routes.first(where: { isSameDay(first: order.pickup.dueAt, second: $0.startDate) }) {
            routeForOrder.addOrder(order: order)
            return AddOrderToRoute(route: routeForOrder, isNew: false)
        } else {
            let newRoute = Route(orders: [order], startDate: onlyDate(date: order.pickup.dueAt), driver: self)
            return AddOrderToRoute(route: newRoute, isNew: true)
        }
    }

    private func releaseOrder(order: Order) {
        print(self.name, "request to claim an order")
        let response = order.unassign()
        if response.result == .success {}
    }

    func sortRoutes() -> [Route] {
        return self.routes.sorted { route1, route2 in
            let dueAt1 = route1.orders.first?.pickup.dueAt ?? .now
            let dueAt2 = route2.orders.first?.pickup.dueAt ?? .now
            return dueAt1 < dueAt2
        }
    }
}

struct AddOrderToRoute {
    var route: Route
    var isNew: Bool
}
