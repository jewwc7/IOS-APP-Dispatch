//
//  MyCreatedOrders.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftData
import SwiftUI

struct MyCreatedOrders: View {
    @Query private var orderModelOrders: [Order]
    @Environment(\.modelContext) private var context // how to CRUD state
    @EnvironmentObject var appState: AppStateManager

    var body: some View {
        // let filteredOrders = orderModelOrders.filter { $0.customer?.id == appState.loggedInCustomer?.id }
        NavigationView {
            if let loggedInCustomer = appState.loggedInCustomer {
                if loggedInCustomer.orders.count > 0 {
                    List {
                        ForEach(loggedInCustomer.orders, id: \.id) { order in
                            NavigationLink(destination: OrderDetails(order: order)) {
                                CustomerOrderCard(order: order)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                } else {
                    Text("No created orders")
                }
            } else {
                Text("No logged in customer")
            }
        }
    }
}

#Preview {
    MyCreatedOrders().modelContainer(for: [Customer.self, Order.self], inMemory: true).environmentObject(AppStateManager())
}

/// The current reading progress for a specific book.
// class ActiveRoute: ObservableObject {
//    let orders: [Order] // book will never change so just use let
//    let route: Route
//    @Published var progress: RouteProgress //adding @Published lets swiftUi know to react to this, similart to @State, // https://stackoverflow.com/questions/74484318/when-to-use-state-vs-published
//
//    init(orders: [Order], route: Route) {
//        self.orders = orders
//        self.progress = RouteProgress(entries: [])
//        self.route = route
//        self.route.status = "Active"
//    }
//
//
//    // Method
//    func firstOrder() -> Order? {
//       return sortOrders().first
//    }
//    func sortOrders()-> [Order]{
//        return self.orders.sorted {$0.pay > $1.pay}
//    }
//    func getProgress(){
//        //want to return the percentage of complete orders vs incomplete.
//        //return
//    }
//    // …
// }
//
// struct RouteProgress {
//    struct Entry : Identifiable {
//        let id: UUID
//        let progress: Double
//        let time: Date
//        let status: String = "Active"
//        let note: String?
//    }
//
//    var entries: [Entry]
// }

/// The current reading progress for a specific book.
// class OrderObservable: ObservableObject {
//    let order: Order // book will never change so just use let
//    @Published var startedAt: Date? = nil
//
//    init(order: Order, startedAt:Date? = nil) {
//        self.order = order
//        self.startedAt = startedAt
//    }
//
//    func late()->Bool{
//        return self.order.dueAt > Date()
//    }
//
// }
