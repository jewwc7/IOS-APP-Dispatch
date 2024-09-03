//
//  ErrorManager.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/29/24.
//

import Combine
import Foundation
import SwiftUI

// Step 1: Create an ObservableObject class
class ErrorManager: ObservableObject {
    // Step 2: Define the @Published variable
    @Published var currentError: BaseError = .init(type: .ValidationError, message: "There was an error")
    var notifcationManager = NotificationManager()

    // Step 3: Create a method to handle errors
    func handleError(_ error: BaseError) {
        currentError = error
        displayError()
    }

    func displayError() {
        notifcationManager.displayNotification {
            Text(self.currentError.message).foregroundColor(.white).font(.footnote).padding()
        }
    }
}
