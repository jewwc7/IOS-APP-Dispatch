//
//  Order.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/20/24.
//

import SwiftData
import Foundation
import CoreData

//To resolve the issue, you need to ensure that OrderStatus conforms to PersistentModel. In SwiftData (and other similar frameworks like Core Data), enums that are used as properties of persistent models typically need to be marked as conforming to Codable so that they can be serialized and deserialized properly.
enum OrderStatus: String, Codable  { //
    case claimed
    case open
    case canceled
}

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
    var due_at: Date
    var startedAt: Date? = nil
    var customer: Customer? = nil
    var status:OrderStatus
    // Initializer
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
            due_at: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()) { //7 days from now or right now
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
           self.due_at = due_at//add time to this date
           self.startedAt = nil
           self.customer = customer
           self.status = OrderStatus.open
       }
    
    // Method
    func introduce() {
        print("Hello, my name is \(orderId) and I am being picked up from \(pickupLocation)  and am to be dropped off at \(dropoffLocation) for a cost of $\(pay).")
    }
    
    func late()->Bool{
        return self.due_at > Date()
    }
    
}


