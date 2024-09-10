//
//  MyCreatedOrdersList.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/4/24.
//

import SwiftData
import SwiftUI

enum MyCreatedOrderSortOrder: String, Identifiable, CaseIterable {
    case pay, status // , pickupDueAt, dropoffDueAt

    var id: Self {
        self
    }
}

// Good amount of sorting and filtering can be used there
// add te picker to MyCreated orders, should also use picker for filtering? Also have a search feature
// THen come back here and make the route screen a tab screen with this one.

struct MyCreatedOrdersList: View {
    var loggedInCustomer: Customer
    @Environment(\.modelContext) private var context // how to CRUD stat
    @Query private var orders: [Order]

    init(loggedInCustomer: Customer, sortOrder: MyCreatedOrderSortOrder) {
        self.loggedInCustomer = loggedInCustomer

        let sortDescriptors: [SortDescriptor<Order>] = switch sortOrder {
        case .pay:
            [SortDescriptor(\Order.pay)]
        case .status: // th
            [SortDescriptor(\Order.status)]
//        case .dropoffDueAt:
//            [SortDescriptor(\Order.dropoff.dueAt)]
        }
        let custId = loggedInCustomer.id // can't put this directly in query. A watchout
        // https://www.hackingwithswift.com/quick-start/swiftdata/how-to-filter-swiftdata-results-with-predicates
        let predicate = #Predicate<Order> { order in
            order.customer?.id == custId
        }
        _orders = Query(filter: predicate, sort: sortDescriptors)
    }

    var body: some View {
        List {
            ForEach(orders, id: \.id) { order in
                NavigationLink(destination: OrderDetails(order: order)) {
                    CustomerOrderCard(order: order)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// #Preview {
//    MyCreatedOrdersList()
// }
