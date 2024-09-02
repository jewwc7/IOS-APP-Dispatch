//
//  DriverOrderScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

import SwiftData
import SwiftUI

struct RouteScreen: View {
    @Environment(\.modelContext) private var context // how to CRUD state
    @EnvironmentObject var appState: AppStateManager
    //    @State private var orderNumber: String = "123"
    //    @State private var pickupLocation: String = "1234 main st"
    //    @State private var pickupPhoneNumber: String = "1234 main st"
    //    @State private var pickupContactName: String = "Mike Jones"
    //    @State private var pickupCompanyOrOrg: String = "Swishahouse"
    //
    //    @State private var dropoffLocation: String = "6789 broadway"
    //    @State private var dropoffPhoneNumber: String = "904-490-7777"
    //    @State private var dropoffContactName: String = "Johnny"
    //    @State private var dropoffCompanyOrOrg: String = "Diamond boys"
    //    @State private var dropoffNotes: String = "Be careful with my diamonds!"
    //

    var body: some View {
        //        @State var tempOrder = Order( orderNumber: orderNumber, pickupLocation: pickupLocation, pickupPhoneNumber: pickupPhoneNumber, pickupContactName: pickupContactName, pickupCompanyOrOrg: pickupCompanyOrOrg, dropoffLocation: dropoffLocation, dropoffPhoneNumber: dropoffPhoneNumber, dropoffContactName: dropoffContactName, dropoffCompanyOrOrg:dropoffCompanyOrOrg, pay: 100, customer: Customer(name: "PlaceHolder customer"))

        ScrollView {
            if let loggedInDriver = appState.loggedInDriver {
                ForEach(loggedInDriver.routes) { route in
                    Section(header: Text(convertDateToDateOnlyString(day: route.startDate)).bold().font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)) {
                        ForEach(route.makeStops(), id: \.id) { stop in
                            DriverStopCard(stop: stop, driver: loggedInDriver)
                        }
                    }
                }
            } else {
                Text("Driver not logged in")
            }
            //    DriverOrderCard(order:tempOrder)
        }
    }
}

#Preview {
    RouteScreen().modelContainer(for: [Order.self, Customer.self, Driver.self], inMemory: true).environmentObject(AppStateManager())
}
