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
   
//    @Environment(\.modelContext) private var context //how to CRUD state
//    @Query private var customers: [Customer]
    @Published var loggedInCustomer: Customer? = nil
    @Published var loggedInDriver: Driver? = Driver(name: "Mike Jones") //this will be set by loginDriver
    
    func login(customer: Customer) {
        print("hey",loggedInCustomer)
      loggedInCustomer = customer
        print("hey",loggedInCustomer)
//        print("Hello, my name is \(orderId) and I am being picked up from \(pickupLocation)  and am to be dropped off at \(dropoffLocation) for a cost of $\(pay).")
    }
    
    //not in use yet, but will be the same thing as the customers just with drivers
    func loginDriver(driver: Driver){
        
    }
    
}

