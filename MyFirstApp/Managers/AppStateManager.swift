//
//  AppStateManager.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/29/24.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

class AppStateManager: ObservableObject {
    @Published var loggedInCustomer: Customer? = nil
    @Published var loggedInDriver: Driver? = nil

    func login(customer: Customer) {
        loggedInCustomer = customer
    }

    // not in use yet, but will be the same thing as the customers just with drivers
    func loginDriver(_ driver: Driver) {
        loggedInDriver = driver
    }
}
