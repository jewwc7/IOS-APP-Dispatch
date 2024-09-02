//
//  Seeds.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/14/24.
//

import Foundation
import SwiftData

func createSeeds(modelContext: ModelContext) {
    let driver = Driver(name: "Paul Wall")
    let customer = Customer(name: "Mike Jones")
    do {
        modelContext.insert(driver)
        modelContext.insert(customer)
        try modelContext.save()
        let order = createOrders(customer: customer)
        let unclaimedOrder = createOrders(customer: customer)
        modelContext.insert(order)
        modelContext.insert(unclaimedOrder)
        try order.modelContext?.save()
        try modelContext.save()
        acceptOrder(driver: driver, order: order)
    } catch {
        print("There was an error creating seeds", error.localizedDescription)
    }
}

// only creates one order at this time
func createOrders(_ numOfOrders: Int = 1, customer: Customer, pickup: Pickup? = nil, dropoff: Dropoff? = nil) -> Order {
    let pickupDueAt = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    let dropoffDueAt = Calendar.current.date(byAdding: .day, value: 8, to: Date()) ?? Date()

    let finalPickup = pickup ?? Pickup(address: "1234 main st", cityStateZip: "Kansas City, MO 64127", locationId: UUID(), phoneNumber: "281-330-8004", contactName: "Mike Jones", company: "Swishahouse", dueAt: pickupDueAt)
    let finaldropoff = dropoff ?? Dropoff(address: "6789 broadway st", cityStateZip: "Kansas City, MO 64111", locationId: UUID(), phoneNumber: "904-490-7777", contactName: "Johnny", company: "Diamond Boys", dueAt: dropoffDueAt)

    let order = Order(orderNumber: "123", pay: 100.00, customer: customer, pickup: finalPickup, dropoff: finaldropoff)

    finalPickup.order = order
    finaldropoff.order = order
    return order
}

func acceptOrder(driver: Driver, order: Order) {
    driver.handleOrderAction(action: DriverOrderAction.claim, order: order)
}
