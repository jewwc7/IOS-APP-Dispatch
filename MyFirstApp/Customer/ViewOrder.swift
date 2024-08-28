//
//  ViewOrder.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftUI

struct ViewOrder: View {
    var order: Order /* ? = createOrders(customer: Customer(name: "Jackie")) */
    var pickup: Pickup
    var dropoff: Dropoff
    
    init(order: Order) {
        self.order = order
        self.pickup = order.pickup
        self.dropoff = order.dropoff
    }
    
    var body: some View {
        let c: Color = order.inProgess() ? .green : order.claimed() ? .blue : .red
        NavigationView {
            List {
                Section(header: Text("Driver status").font(.subheadline)) {
                    VStack {
                        TextChip(title: order.statusTexts[order.status.rawValue] ?? "missing key", bgColor: c, font: .subheadline)
                    }
                }
     
                Section(header: TextChip(title: "Pickup", font: .subheadline)) {
                    VStack(alignment: .leading) {
                        Text("Organization")
                        Text(pickup.company).bold()
                    }.padding(.vertical, 2)
                    
                    VStack(alignment: .leading) {
                        Text("Address")
                        Text(pickup.fullAddress).bold()
                    }.padding(.vertical, 2)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Contact name")
                            Text(pickup.contactName).bold()
                        }
                        VStack(alignment: .leading) {
                            Text("Phone")
                            Text(pickup.phoneNumber).bold()
                        }
                    }
                    .padding(.vertical, 2)
                    .padding(.vertical, 2)
                    VStack(alignment: .leading) {
                        Text("Delivers by")
                        Text(formattedDate(order.pickup.dueAt)).font(.subheadline).bold()
                    }
                }
                
                Section(header: TextChip(title: "Dropoff", font: .subheadline)) {
                    VStack(alignment: .leading) {
                        Text("Organization")
                        Text(dropoff.company).bold()
                    }.padding(.vertical, 2)
                    
                    VStack(alignment: .leading) {
                        Text("Address")
                        Text(dropoff.fullAddress).bold()
                    }.padding(.vertical, 2)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Contact name")
                            Text(dropoff.contactName).bold()
                        }
                        VStack(alignment: .leading) {
                            Text("Phone")
                            Text(dropoff.phoneNumber).bold()
                        }
                    }
                    .padding(.vertical, 2)
                    VStack(alignment: .leading) {
                        Text("Delivers by")
                        Text(formattedDate(order.dropoff.dueAt)).font(.subheadline).bold()
                    }
                }
            }
            .listStyle(GroupedListStyle())
         
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("", systemImage: "plus") {
                    print("Edit order!!")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("", systemImage: "xmark") {
                    print("Cancel order!!")
                }
            }
        }
        .navigationTitle("Order Details")
    }
}

// #Preview {
//    ViewOrder().modelContainer(for: [Order.self, Customer.self, Driver.self], inMemory: true).environmentObject(AppStateModel()) // needs to be added to insert the modelContext, making it possible to CRUD state
//    // https://developer.apple.com/tutorials/develop-in-swift/save-data
// }
