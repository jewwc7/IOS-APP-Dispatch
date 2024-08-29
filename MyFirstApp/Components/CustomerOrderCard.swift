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
    var orderViewModel: OrderViewModel

    init(order: Order) {
        self.order = order
        self.orderViewModel = OrderViewModel(order)
    }

    var body: some View {
        let chipColor: Color = orderViewModel.chipColor()
        VStack {
            VStack(alignment: .leading) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        VStack {
                            HStack {
                                TextChip(title: "Pickup", bgColor: .gray, font: .footnote)
                                Spacer()
                                Text(order.pickup.fullAddressSpaced)
                                    .font(.subheadline).bold()
                            }
                            HStack {
                                TextChip(title: "Dropoff", bgColor: .gray, font: .footnote)
                                Spacer()
                                Text(order.dropoff.fullAddressSpaced)
                                    .font(.subheadline).bold()
                            }.padding(.top, 6)
                        }

                        HStack {
                            Text(formattedDate(order.dropoff.dueAt)).font(.footnote).bold()
                            Spacer()
                            TextChip(title: order.statusTexts[order.status] ?? "missing key", bgColor: chipColor, font: .footnote)
                        }.padding(.vertical, 12)
                    }
                }
            }

        }.frame(maxWidth: .infinity) // .background(.yellow)
    }
}

#Preview {
    CustomerOrderCard(order: testOrderTwo).modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateManager()) // needs to be added to insert the modelContext, making it possible to CRUD state
    // https://developer.apple.com/tutorials/develop-in-swift/save-data
}
