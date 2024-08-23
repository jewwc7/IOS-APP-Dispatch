//
//  ViewOrder.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftUI

// WHere I left off
// works, but is there a way for me to update the actual order permanetly
// when I naivgate far enough back the order goes back to it's orginal state.
// idk if this observable object is what I want for a consistent state,
// seems more like an intermediate state
struct ViewOrder: View {
    var order: Order? = createOrders(customer: Customer(name: "Jackie"))

    var body: some View {
        if let order = order {
            VStack {
                CustomerStopCard(order: order)
            }
        } else {
            EmptyView()
        }
    }

    func formatDate(date: Date) -> String {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        return formatter3.string(from: date)
    }

    func getLabelAndSystemImage(order: Order) -> LabelAndSystemImage {
        if order.delivered() {
            return LabelAndSystemImage(text: "Delivered", image: "checkmark")
        }
        if order.inProgess() {
            return LabelAndSystemImage(text: humanizeCamelCase(order.status.rawValue), image: "car")
        }
        if order.claimed() {
            return LabelAndSystemImage(text: "Claimed", image: "person.fill.checkmark")
            // car and status
        } else {
            return LabelAndSystemImage(text: "Unassigned", image: "magnifyingglass")
        }
    }
}

#Preview {
    ViewOrder().modelContainer(for: [Order.self, Customer.self, Driver.self], inMemory: true).environmentObject(AppStateModel()) // needs to be added to insert the modelContext, making it possible to CRUD state
    // https://developer.apple.com/tutorials/develop-in-swift/save-data
}
