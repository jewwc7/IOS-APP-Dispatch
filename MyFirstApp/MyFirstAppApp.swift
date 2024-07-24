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
    
    init() {
        do {
            modelContainer = try ModelContainer(for: OrderModel.self)
        } catch {
            print(error)
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
            //add this to access state and persist
           // https://developer.apple.com/tutorials/develop-in-swift/save-data
        }
    }
}
