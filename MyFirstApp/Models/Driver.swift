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
class Driver {
    // Properties
    var id: String?
    var name: String
    var numberOfOrdersPlaced: Int
    var isLoggedIn: Bool
    var orders = [Order]() // this and below are the same thing.
    var routes: [Route] = []
    // Initializer
    init(
        name: String = ""

    ) {
        self.id = UUID().uuidString
        self.name = name
        self.numberOfOrdersPlaced = 0
        self.isLoggedIn = false
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
        print(self.name, "request to claim an order")
        let response = order.claim(driver: self)
        if response.result == .success {
            _ = self.addOrderToRoute(order: order)
        }
    }

    func numberOfOrders() -> Int {
        return self.routes.reduce(0) { result, route -> Int in
            return result + route.orders.count
        }
    }

    private func addOrderToRoute(order: Order) -> Route {
        if let routeForOrder = self.routes.first(where: { isSameDay(first: order.pickup.dueAt, second: $0.startDate) }) {
            routeForOrder.addOrder(order: order)
            return routeForOrder
        } else {
            return Route(orders: [order], startDate: onlyDate(date: order.pickup.dueAt), driver: self)
        }
    }

    private func releaseOrder(order: Order) {
        print(self.name, "request to claim an order")
        let response = order.unassign()
        if response.result == .success {}
    }

    func login() -> Result {
        do {
            self.isLoggedIn = true
            print("logging in", self.isLoggedIn)
            try self.modelContext?.save()
            return .success
        }

        catch {
            print(error)
            print("Could not login \(self.name)")
            return .failure
        }
    }
}
