//
//  ContentView.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/6/24.
//

// Big Watch out, enums cause previews to not work if they are assigned to swift data model. Instead assign the Raw value

import SwiftData
import SwiftUI

struct ContentView: View {
    @Query private var orderModelOrders: [Order]
    @Environment(\.modelContext) private var context // how to CRUD state
    @StateObject private var appState = AppStateModel() // this is

    @State var vm = LocationSearchService()

//    let modelContainer: ModelContainer
//
//    init() {
//        do {
//            // TODO: add memory stuff https://www.hackingwithswift.com/quick-start/swiftdata/how-to-add-multiple-configurations-to-a-modelcontainer
//            modelContainer = try ModelContainer(for: Order.self, Customer.self, Driver.self, Pickup.self, Dropoff.self)
//        } catch {
//            print(error)
//            fatalError("Could not initialize ModelContainer")
//        }
//    }

    var body: some View {
        NavigationStack { // If wanting to navigate this has to wrap the entire component
            VStack {
                // this is how to align horizontally
                FirstPage()
                VStack {
                    Button("Show Notification") {
                        appState.displayNotification {
                            Text("Test Notification")
                        }
                    }
                }
            }.navigationViewStyle(.stack)
        }
    }
}

////////////////////////////////////////

#Preview {
    ContentView()
        .modelContainer(for: [Order.self, Customer.self, Driver.self, Route.self], inMemory: true).environmentObject(AppStateModel())
    // add this to access state and persist making it possible to CRUD state
    // https://developer.apple.com/tutorials/develop-in-swift/save-data
}
