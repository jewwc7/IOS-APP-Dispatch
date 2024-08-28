//
//  Order.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/20/24.
//

import Combine
import CoreData
import Foundation
import SwiftData
import SwiftUI

// To resolve the issue, you need to ensure that OrderStatus conforms to PersistentModel. In SwiftData (and other similar frameworks like Core Data), enums that are used as properties of persistent models typically need to be marked as conforming to Codable so that they can be serialized and deserialized properly.
enum OrderStatus: String, Codable { //
    case unassigned
    case canceled
    case claimed
    case enRouteToPickup
    case enRouteToDropOff
    case atPickup
    case atDropoff
    case delivered
}

// enum OrderError: Error {
//    case alreadyClaimed
//    case invalidDriver
// }

@Model
class Order {
    // Properties
    var id: String
    var orderNumber: String?
    var pay: Double
    var startedAt: Date?
    var customer: Customer?
    var driver: Driver?
    var pickup: Pickup
    var dropoff: Dropoff
    var status: OrderStatus = OrderStatus.unassigned
    let statusTexts: [OrderStatus.RawValue: String] = [
        "unassigned": "Unassigned",
        "claimed": "Claimed",
        "enRoute": "Heading to pickup",
        "atPickup": "At pickup",
        "enRouteToDropoff": "Leaving pickup",
        "atDropoff": "At dropoff",
        "delivered": "Delivered",
        "pickedUp": "Picked up", // displays when disabled
        "completeDelivery": "Complete delivery" // display when entire deliv complete
    ]

    let inProgressStatuses: Set<OrderStatus> = [OrderStatus.enRouteToPickup, OrderStatus.atPickup, OrderStatus.atDropoff, OrderStatus.enRouteToDropOff]
    // Note: SwiftData properties do not support willSet or didSet property observers, unless they have @Transient so had to make a transient prop, update this when status is updated. @Transient does not persist the data, so status is not persisted, so this is a workaround
    // https://www.hackingwithswift.com/quick-start/swiftdata/how-to-create-derived-attributes-with-swiftdata
    @Transient var transientStatus: OrderStatus = .unassigned {
        didSet {
            // In Swift, didSet is a property observer that executes a block of code immediately after the value of a property changes. Property observers are used to monitor changes in a property’s value, which allows you to respond to changes in state or value without the need to explicitly call a method or function.
            statusDidChange()
        }
    }

    init(
        orderNumber: String?,
        pay: Double,
        customer: Customer,
        status: OrderStatus = OrderStatus.unassigned,
        driver: Driver? = nil,
        pickup: Pickup,
        dropoff: Dropoff
    ) { // 7 days from now or right now
        self.id = UUID().uuidString
        self.orderNumber = orderNumber
        self.pay = pay
        self.startedAt = nil
        self.customer = customer
        self.driver = driver
        self.status = status
        self.pickup = pickup
        self.dropoff = dropoff
    }

    // check if pickup or dropOff is late
//    func late() -> Bool {
//        return dueAt > Date()
//    }

    func claim(driver: Driver) -> ResultWithMessage {
        let isClaimable = self.isClaimable()
        if isClaimable.result == .success {
            self.driver = driver
            status = OrderStatus.claimed
            return isClaimable
        } else {
            return isClaimable
        }
    }

    private func isClaimable() -> ResultWithMessage {
        if driver != nil {
            return ResultWithMessage(result: .failure, message: "Driver already assigned")
        }
        if status == OrderStatus.canceled {
            return ResultWithMessage(result: .failure, message: "Order was canceled")
        } else {
            return ResultWithMessage(result: .success)
        }
    }

    func handleStatusTransition() {
        if status == .delivered {
            return print("Order already delivered")
        } else if canceled() {
            return print("Canceled order cant be delivered")
        } else if unassigned() {
            status = .claimed
        } else if claimed() { // unassigned only here for testing purposes
            setEnRouteToPickup()
        } else if isEnrouteToPickup() {
            setAtPickup()
        } else if isAtPickup() {
            setEnrouteToDropoff()
        } else if isEnrouteToDropoff() {
            setAtDropoff()
        } else if isAtDropOff() {
            setDelivered()
        }

        do {
            try modelContext?.save()
            transientStatus = status
        } catch {
            print(error)
        }
    }

    func claimed() -> Bool {
        // commented out for testing
        return status == .claimed // && driver != nil
        // return true
    }

    func unassigned() -> Bool {
        return status == .unassigned
    }

    func assigned() -> Bool {
        return status == .claimed && driver != nil
    }

    func started() -> Bool {
        return startedAt != nil
    }

    func canceled() -> Bool {
        return status == .canceled
    }

    func delivered() -> Bool {
        return status == .delivered
    }

    func isEnrouteToPickup() -> Bool {
        return status == .enRouteToPickup
    }

    func isAtPickup() -> Bool {
        return status == .atPickup
    }

    func isEnrouteToDropoff() -> Bool {
        return status == .enRouteToDropOff
    }

    func isAtDropOff() -> Bool {
        return status == .atDropoff
    }

    func inProgess() -> Bool {
        return inProgressStatuses.contains(status)
    }

    private func setEnRouteToPickup() {
        if driver == nil {
            print("order has no driver")
        } else {
            print("setting @ setEnRouteToPickup")
            status = .enRouteToPickup
            startedAt = Date()
        }
    }

    private func setAtPickup() {
        print("setting @ pickup")
        if status != .enRouteToPickup {
            print("please set enroute to pickup first")
        } else {
            status = .atPickup
        }
    }

    private func setEnrouteToDropoff() {
        print("setting @ enrouteToDropoff")
        if status != .atPickup {
            print("please complete pickup first")
        } else {
            status = .enRouteToDropOff
        }
    }

    private func setAtDropoff() {
        print("setting @ dropoff")
        if status != .enRouteToDropOff {
            print("please setEnRouteToDroppoff first pickup first")
        } else {
            status = .atDropoff
        }
    }

    private func setDelivered() {
        print("setting @ delivered")
        if status != .atDropoff {
            print("please setAtDropoff first")
        } else {
            status = .delivered
        }
    }

    func statusDidChange() {
        UIApplication.shared.inAppNotification(adaptForDynmaicIsland: false, timeout: 5, swipeToClose: true) {
            Text("Hi \(self.customer?.name ?? "") your order is now \(humanizeCamelCase(self.status.rawValue))").padding().background(.white)
        }
        // Alternatively, you could call a delegate method, execute a closure, etc.
    }

    func validatePickupAndDropOff(
    ) throws {
        try pickup.validateFields()
        try dropoff.validateFields()
    }
}
