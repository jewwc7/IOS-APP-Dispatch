//
//  ErrorManager.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/27/24.
//

import Combine
import Foundation
import SwiftUI

// Step 1: Create an ObservableObject class
class ErrorManager: ObservableObject {
    // Step 2: Define the @Published variable
    @Published var currentError: BaseError = .init(type: .ValidationError, message: "There was an error")

    // Step 3: Create a method to handle errors
    func handleError(_ error: BaseError) {
        currentError = error
        displayError(currentError.message)
    }

    func displayError(_ message: String) {
        UIApplication.shared.inAppNotification(adaptForDynmaicIsland: false, timeout: 5, swipeToClose: true) {
            VStack(content: {
                /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
            })
            Text(message).padding().background(.red).foregroundColor(.white)
        }
        // Alternatively, you could call a delegate method, execute a closure, etc.
    }
}
