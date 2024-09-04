//
//  AvailableOrderList.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/4/24.
//

import SwiftData
import SwiftUI

enum AvailableOrderSortOrder: String, Identifiable, CaseIterable {
    case pay // , pickupDueAt, dropoffDueAt

    var id: Self {
        self
    }
}

// WHere I left. Add the List portion to the customer my order screen
// Good amount of sorting and filtering can be used there
// THen come back here and make the route screen a tab screen with this one.

struct AvailableOrderList: View {
    var loggedInDriver: Driver
    @Environment(\.modelContext) private var context // how to CRUD state
    @Query private var orders: [Order]

    init(loggedInDriver: Driver, sortOrder: AvailableOrderSortOrder) {
        self.loggedInDriver = loggedInDriver
        let sortDescriptors: [SortDescriptor<Order>] = switch sortOrder {
        case .pay:
            [SortDescriptor(\Order.pay)]
//        case .pickupDueAt: // this did not work. Beleive it can only be it's own columns
//            [SortDescriptor(\Order.pickup.dueAt)]
//        case .dropoffDueAt:
//            [SortDescriptor(\Order.dropoff.dueAt)]
        }

        _orders = Query(sort: sortDescriptors)
    }

    var body: some View {
        let unclaimedOrders = orders.filter { $0.driver == nil }

        ScrollView {
            // ForEach needs to identify its contents in order to perform layout, successfully delegate gestures to child views and other tasks.
            // https://stackoverflow.com/questions/69393430/referencing-initializer-init-content-on-foreach-requires-that-planet-c
            ForEach(unclaimedOrders, id: \.id) { order in
                AvailableOrderCard(order: order, driver: loggedInDriver)
            }
        }
    }
}

//
// #Preview {
//    AvailableOrderList()
// }
