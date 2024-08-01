//
//  MyCreatedOrders.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftUI
import SwiftData


let order = Order( orderNumber: "123", pickupLocation: "1234 main st", pickupPhoneNumber: "281-330-8004", pickupContactName: "Mike Jones", pickupCompanyOrOrg: "Swishahouse", dropoffLocation: "6789 broadway st", dropoffPhoneNumber: "904-490-7777", dropoffContactName: "Johnny", dropoffCompanyOrOrg: "Diamond Boys", pay: 100)

struct MyCreatedOrders: View {
    @Query private var orders: [Order]
    
   private var tempOrders:[Order] = [order]

    var body: some View {
        NavigationView {
            List {
                ForEach(tempOrders, id: \.orderId){ order in
                    NavigationLink(destination: ViewOrder(order:order)) {
                        VStack{
                            HStack{
                                Text("Pickup Address:")
                                Spacer()
                                Text(order.pickupLocation)
                            }
                            HStack{
                                Text("Drop-Off Address:")
                                Spacer()
                                Text(order.dropoffLocation)
                            }
                            if order.startedAt != nil { // order.startedAt != nil
                                Label("started", systemImage: "car").foregroundColor(.green)
                    
                            }
                        }
                    
                    }
                    
                }
            }
            
        }
    }
}

#Preview {
    MyCreatedOrders()
}

/// The current reading progress for a specific book.
class ActiveRoute: ObservableObject {
    let orders: [Order] // book will never change so just use let
    let route: Route
    @Published var progress: RouteProgress //adding @Published lets swiftUi know to react to this, similart to @State, // https://stackoverflow.com/questions/74484318/when-to-use-state-vs-published
    
    init(orders: [Order], route: Route) {
        self.orders = orders
        self.progress = RouteProgress(entries: [])
        self.route = route
        self.route.status = "Active"
    }
    
    
    // Method
    func firstOrder() -> Order? {
       return sortOrders().first
    }
    func sortOrders()-> [Order]{
        return self.orders.sorted {$0.pay > $1.pay}
    }
    func getProgress(){
        //want to return the percentage of complete orders vs incomplete.
        //return
    }
    // …
}

struct RouteProgress {
    struct Entry : Identifiable {
        let id: UUID
        let progress: Double
        let time: Date
        let status: String = "Active"
        let note: String?
    }

    var entries: [Entry]
}


/// The current reading progress for a specific book.
//class OrderObservable: ObservableObject {
//    let order: Order // book will never change so just use let
//    @Published var startedAt: Date? = nil
//    
//    init(order: Order, startedAt:Date? = nil) {
//        self.order = order
//        self.startedAt = startedAt
//    }
//    
//    func late()->Bool{
//        return self.order.due_at > Date()
//    }
//
//}
