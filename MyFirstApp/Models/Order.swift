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
    case unassinged
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
    var orderId: String
    var orderNumber: String?
    var pickupLocation: String
    var pickupPhoneNumber: String
    var pickupContactName: String
    var pickupCompanyOrOrg: String
    var dropoffLocation: String
    var dropoffPhoneNumber: String
    var dropoffContactName: String
    var dropoffCompanyOrOrg: String
    var pay: Int
    var dueAt: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    var startedAt: Date?
    var customer: Customer?
    var driver: Driver?
    var pickup: Pickup
    var dropoff: Dropoff
    var status: OrderStatus = OrderStatus.unassinged
    let statusTexts: [String: String] = [
        "enRoute": "Heading to pickup",
        "atPickup": "At pickup",
        "enRouteToDropoff": "Leaving pickup",
        "atDropoff": "At dropoff",
        "delivered": "Delivered",
        "pickedUp": "Picked up", // displays when disabled
        "completeDelivery": "Complete delivery"
    ]

    let inProgressStatuses: Set<OrderStatus> = [OrderStatus.enRouteToPickup, OrderStatus.atPickup, OrderStatus.atDropoff]
    // Note: SwiftData properties do not support willSet or didSet property observers, unless they have @Transient so had to make a transient prop, update this when status is updated. @Transient does not persist the data, so status is not persisted, so this is a workaround
    // https://www.hackingwithswift.com/quick-start/swiftdata/how-to-create-derived-attributes-with-swiftdata
    @Transient var transientStatus: OrderStatus = .unassinged {
        didSet {
            // In Swift, didSet is a property observer that executes a block of code immediately after the value of a property changes. Property observers are used to monitor changes in a property’s value, which allows you to respond to changes in state or value without the need to explicitly call a method or function.
            statusDidChange()
        }
    }
     
    init(
        orderNumber: String?,
        pickupLocation: String,
        pickupPhoneNumber: String,
        pickupContactName: String,
        pickupCompanyOrOrg: String,
        dropoffLocation: String,
        dropoffPhoneNumber: String,
        dropoffContactName: String,
        dropoffCompanyOrOrg: String,
        pay: Int,
        customer: Customer,
        status: OrderStatus = OrderStatus.unassinged,
        driver: Driver? = nil,
        pickup: Pickup,
        dropoff: Dropoff,
        dueAt: Date? = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    ) { // 7 days from now or right now
        self.orderId = UUID().uuidString
        self.orderNumber = orderNumber
        self.pickupLocation = pickupLocation
        self.pickupPhoneNumber = pickupPhoneNumber
        self.pickupContactName = pickupContactName
        self.pickupCompanyOrOrg = pickupCompanyOrOrg
        self.dropoffLocation = dropoffLocation
        self.dropoffPhoneNumber = dropoffPhoneNumber
        self.dropoffContactName = dropoffContactName
        self.dropoffCompanyOrOrg = dropoffCompanyOrOrg
        self.pay = pay
        self.dueAt = dueAt ?? Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date() // add time to this date
        self.startedAt = nil
        self.customer = customer
        self.driver = driver
        self.status = status
        self.pickup = pickup
        self.dropoff = dropoff
    }
    
    // Method
    func introduce() {
        print("Hello, my name is \(orderId) and I am being picked up from \(pickupLocation)  and am to be dropped off at \(dropoffLocation) for a cost of $\(pay).")
    }
    
    func late() -> Bool {
        return dueAt > Date()
    }
    
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
        return status == .unassinged
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
        print(inProgressStatuses.contains(status), status)
        return inProgressStatuses.contains(status)
    }
    
    func dueAtFormatted() -> String {
        let formatter3 = DateFormatter()
        // formatter3.dateFormat = "HH:mm E, d MMM y"
        formatter3.timeZone = TimeZone.current
        formatter3.dateStyle = .medium
        formatter3.timeStyle = .short
        return formatter3.string(from: dueAt)
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
    
    func validateFields(
        pickupLocation: String,
        pickupPhoneNumber: String,
        pickupContactName: String,
        pickupCompanyOrOrg: String,
        dropoffLocation: String,
        dropoffPhoneNumber: String,
        dropoffContactName: String,
        dropoffCompanyOrOrg: String,
        dueAt: String
    ) throws {
        let fields = [
            ("Pickup location", pickupLocation),
            ("Pickup phone number", pickupPhoneNumber),
            ("Pickup contact name", pickupContactName),
            ("Pickup company or organization", pickupCompanyOrOrg),
            ("Dropoff location", dropoffLocation),
            ("Dropoff phone number", dropoffPhoneNumber),
            ("Dropoff contact name", dropoffContactName),
            ("Dropoff company or organization", dropoffCompanyOrOrg)
        ]
        
        for (fieldName, fieldValue) in fields {
            if fieldValue.isEmpty {
                throw BaseError(type: .ValidationError, message: "Fields are empty")
            }
        }
        let isDropoffBeforePickup = dropoff.dueAt < pickup.dueAt
        if isDropoffBeforePickup {
            throw BaseError(type: .ValidationError, message: "Dropoff can't be before pickup")
        }
        // return ResultWithMessage(result: .success, message: "success") // .failure(.emptyField(message: "\(fieldName) is empty"))
    }
}
