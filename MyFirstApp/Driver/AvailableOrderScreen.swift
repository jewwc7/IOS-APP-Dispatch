//
//  AvailableOrderScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/8/24.
//

import SwiftData
import SwiftUI

struct AvailableOrderScreen: View {
    var driver: Driver
    @State private var waitedToShowIssue = false
    @State private var isLoggedOn = true
    @State private var numberOfOrdersInCart = 0
    
    @Environment(\.modelContext) private var context // how to CRUD state
    @Query private var ordersFromModel: [Order]
    @EnvironmentObject var appState: AppStateModel
    
    var body: some View {
        let unclaimedOrders = ordersFromModel.filter { $0.driver == nil }
        
        if let loggedInDriver = appState.loggedInDriver {
            NavigationView {
                VStack {
                    HStack(alignment: .center) {
                        ZStack {
                            NavigationLink(destination: RouteScreen()) {
                                Image(systemName: "cart.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                     
                            if loggedInDriver.orders.count == 0 {
                                EmptyView()
                            } else {
                                withAnimation {
                                    Text("\(loggedInDriver.numberOfOrders())") // Display your floating number
                                        .font(.system(size: 16)) // Set the font size
                                        .fontWeight(.bold) // Set the font weight if needed
                                        .foregroundColor(.white) // Set the text color
                                        .padding(8) // Add padding around the text
                                        .background(Color.blue) // Set the background color
                                        .clipShape(Circle()) // Clip the text into a circle shape
                                        .offset(x: 16, y: -16) // Offset the text position relative to the image
                                }
                            }
                        }
                    
                        Toggle("", isOn: $isLoggedOn).toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                
                    Text("Available Orders")
                        .font(.title)
                        .fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .leading)
                
                    ScrollView {
                        VStack {
                            // ForEach needs to identify its contents in order to perform layout, successfully delegate gestures to child views and other tasks.
                            // https://stackoverflow.com/questions/69393430/referencing-initializer-init-content-on-foreach-requires-that-planet-c
                            ForEach(unclaimedOrders, id: \.id) { order in
                                AvailableOrderCard(order: order, driver: loggedInDriver) // This is the view returned for each item in the array
                            }
                        }
                    }
                
                }.padding(16)
            }
        } else {
            ContentUnavailableView("No logged in customer", systemImage: "xmark").onAppear(perform: {
                logIn(driver: driver)
            }).opacity(waitedToShowIssue ? 1 : 0).task {
                Task {
                    try await Task.sleep(for: .seconds(1))
                    waitedToShowIssue = true
                }
            }
        }
    }

    func logIn(driver: Driver) {
        let result = driver.login()
        if result == .success {
            appState.loginDriver(driver: driver)
        }
    }
}

// #Preview {
//    AvailableOrderScreen().modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel())
// }
