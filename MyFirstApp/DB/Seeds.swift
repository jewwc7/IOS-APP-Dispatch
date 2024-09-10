//
//  Seeds.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/14/24.
//

import Foundation
import SwiftData

func createSeeds(modelContext: ModelContext) {
    let driver = Driver(name: pickRandomElement(for: "driver", from: namesDictionary) ?? "Random name")
    let customer = Customer(name: pickRandomElement(for: "customer", from: namesDictionary) ?? "Random name")
    do {
        modelContext.insert(driver)
        modelContext.insert(customer)
        try modelContext.save()
        let order = try createOrders(customer: customer)
        let unclaimedOrder = try createOrders(customer: customer)
        modelContext.insert(order)
        modelContext.insert(unclaimedOrder)
        customer.totalNumberOfOrders = 2
        try order.modelContext?.save()
        try modelContext.save()
        try customer.modelContext?.save()
        acceptOrder(driver: driver, order: order)
    } catch {
        print("There was an error creating seeds", error.localizedDescription)
    }
}

// only creates one order at this time
func createOrders(_ numOfOrders: Int = 1, customer: Customer, pickup: Pickup? = nil, dropoff: Dropoff? = nil) throws -> Order {
    let pickupDueAt = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    let dropoffDueAt = Calendar.current.date(byAdding: .day, value: 8, to: Date()) ?? Date()
    let pickupDropoffData = createPickupDropoffData()
    let dropoffData = createPickupDropoffData()
    if
        let streetAddress = pickupDropoffData["streetAddress"],
        let cityStateZip = pickupDropoffData["cityStateZip"],
        let contactName = pickupDropoffData["contactName"],
        let organization = pickupDropoffData["organization"],
        let dostreetAddress = dropoffData["streetAddress"],
        let docityStateZip = dropoffData["cityStateZip"],
        let docontactName = dropoffData["contactName"],
        let doorganization = dropoffData["organization"]
    {
        let finalPickup = pickup ?? Pickup(address: streetAddress, cityStateZip: cityStateZip, locationId: UUID(), phoneNumber: "281-330-8004", contactName: contactName, company: organization, dueAt: pickupDueAt)
        let finaldropoff = dropoff ?? Dropoff(address: dostreetAddress, cityStateZip: docityStateZip, locationId: UUID(), phoneNumber: "904-490-7777", contactName: docontactName, company: doorganization, dueAt: dropoffDueAt)

        let order = Order(orderNumber: String(Int.random(in: 1 ... 1000)), pay: randomPay(), customer: customer, pickup: finalPickup, dropoff: finaldropoff)

        finalPickup.order = order
        finaldropoff.order = order
        return order
    }
    throw BaseError(type: .ValidationError, message: "Seeds corrupted")
}

func acceptOrder(driver: Driver, order: Order) {
    driver.handleOrderAction(action: DriverOrderAction.claim, order: order)
}
