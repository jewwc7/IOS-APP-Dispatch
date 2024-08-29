//
//  OrderCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

//
//  AvailableOrderScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/8/24.
//

import Foundation // how I use random number
import SwiftData
import SwiftUI

let testOrder = createOrders(customer: Customer(name: "Frank"))
let testDriver = Driver(name: "Hank")

struct AvailableOrderCard: View {
    @State private var isExpanded: Bool = false
    var order: Order
    var driver: Driver

    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack {
                            TextChip(title: "Pickup", bgColor: .blue, font: .footnote)
                            Text(formattedDate(order.pickup.dueAt)).font(.footnote).bold().foregroundStyle(.red)
                        }

                        Text(order.pickup.fullAddressSpaced)
                            .font(.subheadline).bold()
                    }

                    Spacer(minLength: 20)

                    VStack(alignment: .leading) {
                        HStack {
                            TextChip(title: "Dropoff", bgColor: .orange, font: .footnote)
                            Text(formattedDate(order.dropoff.dueAt)).font(.footnote).bold().foregroundStyle(.red)
                        }

                        Text(order.dropoff.fullAddressSpaced)
                            .font(.subheadline).bold()
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

            HStack {
                MyButton(title: "Accept", onPress: claim, backgroundColor: Color.blue, image: "checkmark", frame: buttonFrame)

                Spacer() // how to space evenly

                MyButton(title: "Decline", titleColor: Color.red, onPress: decline, image: "xmark", frame: buttonFrame, buttonType: ButtonType.clear)
            } // .frame(width: 60).padding(20)

            // Content
            if isExpanded { // needs to be it's on expanded card?
                ExpandedDriverStopCard(stop: order.pickup) {}.transition(.opacity) // Transition effect when expanding/collapsing
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                ExpandedDriverStopCard(stop: order.dropoff) {}.transition(.opacity) // Transition effect when expanding/collapsing
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

    func claim() {
        driver.handleOrderAction(action: DriverOrderAction.claim, order: order)
    }

    func decline() {
        print("Order \(order.id) declined")
    }
}

// #Preview {
//    AvailableOrderCard(order: testOrderTwo, driver: testDriver).modelContainer(for: [Order.self, Customer.self, Pickup.self, DropofftestDriver.self], inMemory: true).environmentObject(AppStateManager()) // needs to be added to insert the modelContext, making it possible to CRUD state
//    // https://developer.apple.com/tutorials/develop-in-swift/save-data
// }

// driver
// #Preview {
//    ModelPreview { order in
//        AvailableOrderCard(order: order, driver: Driver(name: "Hank"))
//    }.environmentObject(AppStateManager())
// }
