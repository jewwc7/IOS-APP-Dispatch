//
//  CustomerOrderCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/28/24.
//

import SwiftData
import SwiftUI

let testOrderTwo = createOrders(customer: Customer(name: "Jake"))
// Fix the ViewOrder screen
// Then work on sorting/filtering these based on status
struct CustomerOrderCard: View {
    @State private var isExpanded: Bool = false
    var order: Order

    var body: some View {
        let c: Color = order.inProgess() ? .green : order.claimed() ? .blue : .red
        VStack {
            VStack(alignment: .leading) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        VStack {
                            HStack {
                                TextChip(title: "Pickup", font: .subheadline)
                                Spacer()
                                Text(order.pickup.fullAddressSpaced)
                                    .font(.headline).bold()
                            }
                            HStack {
                                TextChip(title: "Dropoff", bgColor: .orange, font: .subheadline)
                                Spacer()
                                Text(order.dropoff.fullAddressSpaced)
                                    .font(.headline).bold()
                            }.padding(.top, 6)
                        }

                        HStack {
                            Text(formattedDate(order.dropoff.dueAt)).font(.subheadline).bold()
                            Spacer()
                            TextChip(title: order.statusTexts[order.status.rawValue] ?? "missing key", bgColor: c, font: .subheadline)
                        }.padding(.vertical, 12)
                    }
                }
            }

        }.frame(maxWidth: .infinity) // .background(.yellow)
    }
}

#Preview {
    CustomerOrderCard(order: testOrderTwo).modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel()) // needs to be added to insert the modelContext, making it possible to CRUD state
    // https://developer.apple.com/tutorials/develop-in-swift/save-data
}
