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
class Customer: BaseModel {
    // Properties
    var id: String?
    var name: String
    var orders = [Order]()
    var totalNumberOfOrders: Int // this is here because sorting only works with column fields
    var createdAt: Date
    var updatedAt: Date
    // Initializer
    init(
        name: String = ""

    ) {
        self.id = UUID().uuidString
        self.name = name
        self.totalNumberOfOrders = 0
        self.createdAt = .now
        self.updatedAt = .now
    }

    func handleOrderAction(action: CustomerOrderAction, order: Order) throws {
        do {
            switch action {
            case CustomerOrderAction.place:
                try self.placeOrder(order: order)
            case CustomerOrderAction.cancel:
                self.cancelOrder(order)
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
        self.totalNumberOfOrders += 1
        Logger.log(.action, "#placeOrder")
    }

    private func cancelOrder(_ order: Order) {
        let response = order.cancel()
        if response.result != .success {
            Logger.log(.action, " \(response.message ?? "") in \(#function)")
            return // throw an error
        }
    }
}
