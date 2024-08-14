//
//  Seeds.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/14/24.
//

import Foundation
import SwiftData


func createSeeds(modelContext: ModelContext){
    let driver = Driver(name:"Paul Wall")
    let customer = Customer(name: "Mike Jones")
    do {
        modelContext.insert(driver)
        modelContext.insert(customer)
        let order = createOrders(customer: customer)
        modelContext.insert(order)
        acceptOrder(driver: driver, order: order)
    }
}

func createOrders(numOfOrders: Int = 1, customer:Customer) -> Order{
 return Order( orderNumber: "123", pickupLocation: "1234 main st", pickupPhoneNumber: "281-330-8004", pickupContactName: "Slim", pickupCompanyOrOrg: "Swishahouse", dropoffLocation: "6789 broadway st", dropoffPhoneNumber: "904-490-7777", dropoffContactName: "Johnny", dropoffCompanyOrOrg: "Diamond Boys", pay: 100, customer: customer)
}

func acceptOrder(driver:Driver, order:Order){
    driver.handleOrderAction(action: DriverOrderAction.claim, order: order)
}
