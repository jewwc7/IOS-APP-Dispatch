//
//  ExpandedDriverStopCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/26/24.
//

import SwiftUI

struct ExpandedDriverStopCard<Content: View>: View {
    var stop: Stop
    var driver: Driver
    var buttonContent: (() -> Content?)? = nil

    init(stop: Stop, driver: Driver, @ViewBuilder buttonContent: @escaping () -> Content? = { nil }) {
        self.stop = stop
        self.driver = driver
        self.buttonContent = buttonContent
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Organization")
                Text(stop.company).bold()
            }.padding(.vertical, 2)

            VStack(alignment: .leading) {
                Text("Address")
                Text(stop.fullAddressSpaced).bold()
            }.padding(.vertical, 2)
            HStack {
                VStack(alignment: .leading) {
                    Text("Contact name")
                    Text(stop.contactName).bold()
                }
                VStack(alignment: .leading) {
                    Text("Phone")
                    Text(stop.phoneNumber).bold()
                }
            }
            .padding(.vertical, 2)

            Divider()

            Spacer()
            if let buttonContent = buttonContent {
                buttonContent()
            }

        }.padding().overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
    }

    func handleOnPress() {
        withAnimation(.smooth) {
            if let order = stop.order {
                order.claim(driver: driver) // should be claim as that;s all I you should be able to do here
                // probably need to pass the driver to this
                //  order.transitionToNextStatus()
            } else {
                print("stop has no associated order")
            }
        }
    }
}

// #Preview {
//    ExpandedDriverStopCard()
// }
