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
    @State private var sortOrder: AvailableOrderSortOrder = .pay

    @Environment(\.modelContext) private var context // how to CRUD state
    @EnvironmentObject var appState: AppStateManager

    var body: some View {
        if let loggedInDriver = appState.loggedInDriver {
            NavigationView {
                VStack {
                    HStack(alignment: .center) {
                        if let hasRoute = loggedInDriver.routes.first {
                            ZStack {
                                NavigationLink(destination: RouteScreen()) {
                                    Image(systemName: "cart.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                }

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
                        } else {
                            ContentUnavailableView("No Routes", systemImage: "truck.box")
                        }

                        // Toggle("", isOn: $isLoggedOn).toggleStyle(SwitchToggleStyle(tint: .blue))
                    }

                    Picker("", selection: $sortOrder) {
                        ForEach(AvailableOrderSortOrder.allCases) { sortOrder in
                            Text("Sort by \(sortOrder.rawValue)").tag(sortOrder)
                        }
                    }.buttonStyle(.bordered)

                    AvailableOrderList(loggedInDriver: driver, sortOrder: sortOrder)
                } // .padding(16)
            }.onAppear(perform: {
                appState.loginDriver(driver)
            }).navigationTitle("Available Orders")
        } else {
            ContentUnavailableView("No logged in customer", systemImage: "xmark").onAppear(perform: {
                appState.loginDriver(driver)
            }).opacity(waitedToShowIssue ? 1 : 0).task {
                Task {
                    try await Task.sleep(for: .seconds(1))
                    waitedToShowIssue = true
                }
            }
        }
    }
}

// #Preview {
//    AvailableOrderScreen().modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateManager())
// }
