//
//  NotificationManager.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/29/24.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

class NotificationManager: ObservableObject {
    // Passing something to viewbuilder via a closure and not directly into the function params
    // In the displayNotification function within your AppStateManager class, viewBuilder is defined as a parameter of type @escaping () -> Content. This means viewBuilder is a closure that takes no arguments and returns an instance of Content, where Content conforms to the View protocol. The @escaping attribute indicates that the closure can escape the function, allowing it to be stored or executed later, which is necessary for asynchronous operations or operations that happen outside the immediate scope of the function, such as displaying a notification
    func displayNotification<Content: View>(viewBuilder: @escaping () -> Content) {
        UIApplication.shared.inAppNotification(adaptForDynmaicIsland: false, timeout: 2, swipeToClose: true) {
            GeometryReader { geometry in // added the geometry so can fit across the screen
                VStack(content: {
                    viewBuilder()
                }).frame(width: geometry.size.width)
                    .background(.black)
                    .shadow(color: .black, radius: 10, x: 0, y: 1)
            }
        }
    }
}
