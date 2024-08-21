//
//  MyFirstAppApp.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/6/24.
//

import SwiftData
import SwiftUI

@main
struct MyFirstAppApp: App {
    let modelContainer: ModelContainer
    @StateObject private var appState = AppStateModel() // this is
    @State private var overlayWindow: PassThroughWindow?

    init() {
        do {
            // TODO: add memory stuff https://www.hackingwithswift.com/quick-start/swiftdata/how-to-add-multiple-configurations-to-a-modelcontainer
            modelContainer = try ModelContainer(for: Order.self, Customer.self, Driver.self)
            // modelContainer.deleteAllData() // hack when adding props to models, phone still has old model data let this run on phone => error will happen=> comment it out => run on phone again and all is well
            // need to
        } catch {
            print(error)
            fatalError("Could not initialize ModelContainer with error \(error.localizedDescription) ")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .environmentObject(appState).onAppear(perform: {
                    // adding overlay so the notification can appear in front of any element(bottom sheets, etc)
                    if overlayWindow == nil {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            let overlayWindow = PassThroughWindow(windowScene: windowScene)
                            overlayWindow.backgroundColor = .clear
                            let controller = UIViewController()
                            controller.view.backgroundColor = .clear
                            overlayWindow.rootViewController = controller
                            overlayWindow.isHidden = false
                            overlayWindow.isUserInteractionEnabled = true
                            self.overlayWindow = overlayWindow
                            print("Overlay window created")
                        }
                    }
                })
            // this is how I keep Observables persisted thought all view
            // add this to access state and persist
            // https://developer.apple.com/tutorials/develop-in-swift/save-data
        }
    }
}

// https://youtu.be/MPp7b9bIUPY?t=832
// Since there is an overlay window above main window we can't interact with the main windows content.We need to convert our overlay window to a pass through window, which will pass its interaction to the underneath window
private class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}
