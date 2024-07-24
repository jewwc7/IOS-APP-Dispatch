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
//            let config1 = ModelConfiguration(for: Recipe.self)
//                        let config2 = ModelConfiguration(for: Comment.self, isStoredInMemoryOnly: true)
//
//                        container = try ModelContainer(for: Recipe.self, Comment.self, configurations: config1, config2)
            modelContainer = try ModelContainer(for: AppModel.self)

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
