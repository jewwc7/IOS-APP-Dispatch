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
        UIApplication.shared.inAppNotification(adaptForDynmaicIsland: false, timeout: 2, swipeToClose: true) {
            GeometryReader { geometry in
                VStack(content: {
                    Text(message).foregroundColor(.white).font(.subheadline)
                }).frame(width: geometry.size.width, height: 60) // .overlay(  //looks funny, think because some UI is controlled withinAppNotification
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.red, lineWidth: 0.5)
//                )
                    .background(.black)
                // .shadow(color: .black, radius: 10, x: 0, y: 5)
            }
        }
        // Alternatively, you could call a delegate method, execute a closure, etc.
    }
}
