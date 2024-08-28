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

struct AvailableOrderCard: View {
    @State private var isExpanded: Bool = false
    var order: Order
    var driver: Driver

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

            HStack {
                MyButton(title: "Accept", onPress: claim, backgroundColor: Color.blue, image: "checkmark", frame: buttonFrame)

                Spacer() // how to space evenly

                MyButton(title: "Decline", titleColor: Color.red, onPress: decline, image: "xmark", frame: buttonFrame, buttonType: ButtonType.clear)
            } // .frame(width: 60).padding(20)

            // Content
            if isExpanded { // needs to be it's on expanded card?
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
        let statusText = statusTexts[order.status] ?? "missing key"

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

    func claim() {
        driver.handleOrderAction(action: DriverOrderAction.claim, order: order)
    }

    func decline() {
        print("Order \(order.id) declined")
    }
}

#Preview {
    CustomerOrderCard(order: testOrderTwo).modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel()) // needs to be added to insert the modelContext, making it possible to CRUD state
    // https://developer.apple.com/tutorials/develop-in-swift/save-data
}

// #Preview {
//    ModelPreview { order in
//        DriverStopCard(order: order)
//    }.environmentObject(AppStateModel())
// }

// #Preview {
//    ModelPreview { order in
//        AvailableOrderCard(order: order, driver: Driver(name: "Hank"))
//    }.environmentObject(AppStateModel())
// }
