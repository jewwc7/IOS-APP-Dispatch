//
//  AppState.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/24/24.
//


import SwiftData
import Foundation
import SwiftUI
import Combine



class AppStateModel: ObservableObject {
    // Properties
    @Published var loggedInCustomer: Customer?
    
    func introduce() {
//        print("Hello, my name is \(orderId) and I am being picked up from \(pickupLocation)  and am to be dropped off at \(dropoffLocation) for a cost of $\(pay).")
    }
    
}

