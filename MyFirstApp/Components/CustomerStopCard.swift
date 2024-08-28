//
//  CustomerStopCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/14/24.
//

import SwiftData
import SwiftUI

let testOrderTwo = createOrders(customer: Customer(name: "Jake"))

struct CustomerStopCard: View {
    @State private var isExpanded: Bool = false
    var order: Order

    var body: some View {
        let labelAndSytemImage = getLabelAndSystemImage(order: order)

        VStack(alignment: .leading) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Pickup: \(order.pickup.fullAddress)")
                        .font(.headline)
                    Text("Dropoff: \(order.dropoff.fullAddress)")
                        .font(.headline)
//                        .padding()
                    MyChip(text: formattedDate(order.dropoff.dueAt))

                    if let orderDriver = order.driver {
                        HStack {
                            Image(systemName: "person").foregroundColor(.green)
                            Text(orderDriver.name)
                        }.padding(.vertical, 6)
                    } else {
                        Label(labelAndSytemImage.text, systemImage: labelAndSytemImage.image).foregroundColor(.green)
                    }
                }.padding()

                Spacer()
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .padding()
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)

            // Content
            if isExpanded {
                ExpandedCustomerStopCard(stop: order.pickup).transition(.opacity) // Transition effect when expanding/collapsing
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                ExpandedCustomerStopCard(stop: order.dropoff).transition(.opacity) // Transition effect when expanding/collapsing
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 5)
    }

    func getLabelAndSystemImage(order: Order) -> LabelAndSystemImage {
        let statusTexts = order.statusTexts
        let statusText = statusTexts[order.status.rawValue] ?? "missing key"

        if order.delivered() {
            return LabelAndSystemImage(text: statusText, image: "checkmark")
        }
        if order.inProgess() {
            return LabelAndSystemImage(text: statusText, image: "car")
        }
        if order.claimed() {
            return LabelAndSystemImage(text: statusText, image: "person.fill.checkmark")
            // car and status
        } else {
            return LabelAndSystemImage(text: statusText, image: "magnifyingglass")
        }
    }
}

#Preview {
    CustomerStopCard(order: testOrderTwo).modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel()) // needs to be added to insert the modelContext, making it possible to CRUD state
    // https://developer.apple.com/tutorials/develop-in-swift/save-data
}
