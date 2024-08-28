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

enum CustomerOrderAction {
    case place
    case cancel
}

// when adding a new one I need to add default values
// these are run in migrations,
// will get error if default values missing https://forums.developer.apple.com/forums/thread/746577
@Model
class Customer {
    // Properties
    var id: String?
    var name: String
    var numberOfOrdersPlaced: Int
    var isLoggedIn: Bool
    var orders = [Order]()

    // Initializer
    init(
        name: String = ""

    ) {
        self.id = UUID().uuidString
        self.name = name
        self.numberOfOrdersPlaced = 0
        self.isLoggedIn = false
    }

    func handleOrderAction(action: CustomerOrderAction, order: Order) throws {
        do {
            switch action {
            case CustomerOrderAction.place:
                try self.placeOrder(order: order)
            case CustomerOrderAction.cancel:
                self.cancelOrder()
            }
        } catch let error as BaseError { // Swift checks if the error thrown conforms to the BaseError type or is a subclass of BaseError
            print(self, ["message": error.message, "type": error.type])
            throw error // let error bubble up
        } catch {
            print(self, error.localizedDescription)
            throw error
        }
    }

    private func placeOrder(order: Order) throws {
        print(self.name, "requested to place an order")

        try order.validatePickupAndDropOff() // don't include do-catch so error can bubble up
        self.orders.append(order)
        self.numberOfOrdersPlaced += 1
        print(self.name, "placed an order!")
        // FInd the order and run some comandds on it
    }

    private func cancelOrder() {
        print(self.name, "canceled an order")
        self.numberOfOrdersPlaced += 1
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
