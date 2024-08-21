//
//  ModelPreview.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/21/24.
//

import SwiftData
import SwiftUI

//https://www.youtube.com/watch?v=toE81AHrsYA
struct ModelPreview<Model: PersistentModel, Content: View>: View {
    var content: (Model) -> Content

    init(@ViewBuilder content: @escaping (Model) -> Content) {
        self.content = content
    }

    var body: some View {
        PrviewContentView(content: content).modelContainer(previewContainer).environmentObject(AppStateModel())
    }

    struct PrviewContentView: View {
        @Query private var models: [Model]
        var content: (Model) -> Content
        @State private var waitedToShowIssue = false

        var body: some View {
            if let model = models.first {
                content(model)
            } else {
                ContentUnavailableView("Could not load model for previews", systemImage: "xmark")
                    .opacity(waitedToShowIssue ? 1 : 0).task {
                        Task {
                            try await Task.sleep(for: .seconds(1))
                            waitedToShowIssue = true
                        }
                    }
            }
        }
    }
}

// #Preview {
//    ModelPreview()
// }
