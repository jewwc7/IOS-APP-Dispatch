//
//  MyFirstAppApp.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/6/24.
//

import SwiftUI
import SwiftData

@main
struct MyFirstAppApp: App {
    let modelContainer: ModelContainer
    @StateObject private var appState = AppStateModel() // this is
    
    init() {
        do {
            
            //TODO: add memory stuff https://www.hackingwithswift.com/quick-start/swiftdata/how-to-add-multiple-configurations-to-a-modelcontainer
            modelContainer = try ModelContainer(for: Order.self, Customer.self)
            // modelContainer.deleteAllData() // hack when adding props to models, phone still has old model data let this run on phone => error will happen=> comment it out => run on phone again and all is well
            // need to
        } catch {
            print(error)
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .environmentObject(appState) //this is how I keep Observables persisted thought all view
            //add this to access state and persist
           // https://developer.apple.com/tutorials/develop-in-swift/save-data
        }
    }
}

