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
    
    var claimed: Bool {
        // commented out for testing
        return comparableStatus == .claimed && driver != nil
        // return true
    }
    
    var unassigned: Bool {
        return comparableStatus == .unassigned
    }
    
    var assigned: Bool {
        return comparableStatus == .claimed && driver != nil
    }
    
    var started: Bool {
        return startedAt != nil
    }
    
    var canceled: Bool {
        return comparableStatus == .canceled
    }
    
    var delivered: Bool {
        return comparableStatus == .delivered
    }
    
    var enrouteToPickup: Bool {
        return comparableStatus == .enRouteToPickup
    }
    
    var atPickup: Bool {
        return comparableStatus == .atPickup
    }
    
    var enrouteToDropoff: Bool {
        return comparableStatus == .enRouteToDropoff
    }
    
    var atDropoff: Bool {
        return comparableStatus == .atDropoff
    }
    
    var inProgess: Bool {
        return inProgressStatuses.contains(comparableStatus)
    }
    
    // Note: SwiftData properties do not support willSet or didSet property observers, unless they have @Transient so had to make a transient prop, update this when status is updated. @Transient does not persist the data, so status is not persisted, so this is a workaround
    // https://www.hackingwithswift.com/quick-start/swiftdata/how-to-create-derived-attributes-with-swiftdata
    @Transient var transientStatus: OrderStatus.RawValue = OrderStatus.unassigned.rawValue {
        didSet {
            // In Swift, didSet is a property observer that executes a block of code immediately after the value of a property changes. Property observers are used to monitor changes in a property’s value, which allows you to respond to changes in state or value without the need to explicitly call a method or function.
            statusDidChange()
        }
    }
    
    var matchingTransition: IOrderTransitionState {
        let matchingTransition: IOrderTransitionState = { switch comparableStatus {
        case .unassigned:
            ClaimedConcreteState(self)
        case .canceled:
            CanceledConcreteState(self)
        case .claimed:
            ClaimedConcreteState(self)
        case .enRouteToPickup:
            EnrouteToPickupConcreteState(self)
        case .atPickup:
            AtPickupConcreteState(self)
        case .enRouteToDropoff:
            EnRouteToDropoffConcreteState(self)
        case .atDropoff:
            AtDropoffConcreteState(self)
        case .delivered:
            DeliveredConcreteState(self)
        }
        }()
        return matchingTransition
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
    
    func unassign(driver: Driver) -> TransitionResult {
        let orderContext = OrderContext(state: matchingTransition)
        let transition = orderContext.transisitionToUnassigned()
        //    let isClaimable = self.isClaimable()
        if transition.result == .success {
            self.driver = nil
        }
        return transition
    }
    
    func claim(driver: Driver) -> TransitionResult {
        let orderContext = OrderContext(state: matchingTransition)
        let transition = orderContext.transitionToClaimed()
        //    let isClaimable = self.isClaimable()
        if transition.result == .success {
            self.driver = driver
            statusDidChange()
        }
        return transition
    }
    
    func transitionToNextStatus() {
        let orderContext = OrderContext(state: matchingTransition)
        let result = orderContext.transitionToNextState()
        if result.result == .success {
            statusDidChange()
            // don't tthink I need this success message
//           try modelContext?.save()
        }
    }
    
    // don't think I need this transient status anymore either, think I can just call this here or in the transistions. Can do diff Notification depending on the state
    func statusDidChange() {
        NotificationManager().displayNotification {
            Text("Hi \(self.customer?.name ?? "") your order is now \(self.statusTexts[self.status] ?? "missing key")").foregroundStyle(.white).padding().font(.footnote)
        }
        // Alternatively, you could call a delegate method, execute a closure, etc.
    }
    
    func validatePickupAndDropOff(
    ) throws {
        try pickup.validateFields()
        try dropoff.validateFields()
    }
    
    func cancel() {
        var o = OrderContext(state: matchingTransition)
        let transition = o.transitionToCancel()
        if transition.result == .success {
            // do some other stuff, send out a notfication
        } else {
            // send out a sepearte notifcation, or change the ui somehow?
        }
    }
}
