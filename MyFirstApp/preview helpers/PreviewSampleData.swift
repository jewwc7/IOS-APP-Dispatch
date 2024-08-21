//
//  PreviewSampleData.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/21/24.
//

import Foundation
import SwiftData

// https://www.youtube.com/watch?v=toE81AHrsYA
let previewContainer: ModelContainer = {
    do {
        // TODO: add memory stuff https://www.hackingwithswift.com/quick-start/swiftdata/how-to-add-multiple-configurations-to-a-modelcontainer
        let modelContainer = try ModelContainer(for: Order.self, Customer.self, Driver.self)

        Task { @MainActor in
            let context = modelContainer.mainContext
            createSeeds(modelContext: context) // I create data so there is data to read in prviews, without the previews will be empty. 
        }

        return modelContainer
    } catch {
        fatalError("Could not initialize ModelContainer for previews with error \(error.localizedDescription)")
    }
}()
