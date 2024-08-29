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
enum OrderStatus: String, Codable, CaseIterable { //
    case unassigned
    case canceled
    case claimed
    case enRouteToPickup
    case enRouteToDropoff
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
    var status: OrderStatus.RawValue
    let statusTexts: [OrderStatus.RawValue: String] = [
        "canceled": "Canceled",
        "unassigned": "Unassigned",
        "claimed": "Claimed",
        "enRouteToPickup": "Heading to pickup",
        "atPickup": "At pickup",
        "enRouteToDropoff": "Leaving pickup",
        "atDropoff": "At dropoff",
        "delivered": "Delivered"
    ]

    var comparableStatus: OrderStatus { // this is needed for switch statements, anytime I want to compare OrderStatus directly
        return OrderStatus(rawValue: status)! // unwrap because status is guaranteed
    }

    let inProgressStatuses: Set<OrderStatus> = [OrderStatus.enRouteToPickup, OrderStatus.atPickup, OrderStatus.atDropoff, OrderStatus.enRouteToDropoff]

    var claimedStatuses: [OrderStatus] {
        return OrderStatus.allCases.filter { $0 != .canceled && $0 != .unassigned }
    }

    // Note: SwiftData properties do not support willSet or didSet property observers, unless they have @Transient so had to make a transient prop, update this when status is updated. @Transient does not persist the data, so status is not persisted, so this is a workaround
    // https://www.hackingwithswift.com/quick-start/swiftdata/how-to-create-derived-attributes-with-swiftdata
    @Transient var transientStatus: OrderStatus.RawValue = OrderStatus.unassigned.rawValue {
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
        self.status = OrderStatus.unassigned.rawValue
        self.customer = customer
        self.driver = driver
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
            status = OrderStatus.claimed.rawValue
            return isClaimable
        } else {
            return isClaimable
        }
    }

    private func isClaimable() -> ResultWithMessage {
        if assigned() {
            return ResultWithMessage(result: .failure, message: "Driver already assigned")
        }
        if canceled() {
            return ResultWithMessage(result: .failure, message: "Order was canceled")
        } else {
            return ResultWithMessage(result: .success)
        }
    }

    func handleStatusTransition() {
        if delivered() {
            return print("Order already delivered")
        } else if canceled() {
            return print("Canceled order cant be delivered")
        } else if unassigned() {
            status = OrderStatus.claimed.rawValue
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
        return comparableStatus == .claimed && driver != nil
        // return true
    }

    func unassigned() -> Bool {
        return comparableStatus == .unassigned
    }

    func assigned() -> Bool {
        return comparableStatus == .claimed && driver != nil
    }

    func started() -> Bool {
        return startedAt != nil
    }

    func canceled() -> Bool {
        return comparableStatus == .canceled
    }

    func delivered() -> Bool {
        return comparableStatus == .delivered
    }

    func isEnrouteToPickup() -> Bool {
        return comparableStatus == .enRouteToPickup
    }

    func isAtPickup() -> Bool {
        return comparableStatus == .atPickup
    }

    func isEnrouteToDropoff() -> Bool {
        return comparableStatus == .enRouteToDropoff
    }

    func isAtDropOff() -> Bool {
        return comparableStatus == .atDropoff
    }

    func inProgess() -> Bool {
        return inProgressStatuses.contains(comparableStatus)
    }

    private func setEnRouteToPickup() {
        if !claimed() {
            print("order has no driver or is not set to claimed")
        } else {
            print("setting @ setEnRouteToPickup")
            status = OrderStatus.enRouteToPickup.rawValue
            startedAt = Date()
        }
    }

    private func setAtPickup() {
        print("setting @ pickup")
        if comparableStatus != .enRouteToPickup {
            print("please set enroute to pickup first")
        } else {
            status = OrderStatus.atPickup.rawValue
        }
    }

    private func setEnrouteToDropoff() {
        print("setting @ enrouteToDropoff")
        if comparableStatus != .atPickup {
            print("please complete pickup first")
        } else {
            status = OrderStatus.enRouteToDropoff.rawValue
        }
    }

    private func setAtDropoff() {
        print("setting @ dropoff")
        if comparableStatus != .enRouteToDropoff {
            print("please setEnRouteToDroppoff first pickup first")
        } else {
            status = OrderStatus.atDropoff.rawValue
        }
    }

    private func setDelivered() {
        print("setting @ delivered")
        if comparableStatus != .atDropoff {
            print("please setAtDropoff first")
        } else {
            status = OrderStatus.delivered.rawValue
        }
    }

    func statusDidChange() {
        NotificationManager().displayNotification {
            Text("Hi \(self.customer?.name ?? "") your order is now \(self.statusTexts[self.status] ?? "missing key")").foregroundStyle(.white).padding().font(.footnote)
        }
        // Alternatively, you could call a delegate method, execute a closure, etc.
    }

    func chipColor() -> Color { // look to move this somewhere else,
        return inProgess() || delivered() ? .green : claimed() ? .blue : .red
    }

    func validatePickupAndDropOff(
    ) throws {
        try pickup.validateFields()
        try dropoff.validateFields()
    }
}
