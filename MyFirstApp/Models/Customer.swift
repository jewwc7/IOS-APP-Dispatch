//
//  Customer.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/25/24.
//


import SwiftData
import Foundation
import CoreData
//NSObject, NSFetchRequestResult, Identifiable

enum CustomerOrderAction {
    case place
    case cancel
}


//when adding a new one I need to add default values
// these are run in migrations,
// will get error if default values missing https://forums.developer.apple.com/forums/thread/746577
@Model
class Customer {
    // Properties
    var id: String?
    var name: String
    var numberOfOrdersPlaced: Int
    var isLoggedIn: Bool
    var orders = [Order]()
    
    // Initializer
    init(
        name: String = ""
        
    ) {
        self.id = UUID().uuidString
        self.name = name
        self.numberOfOrdersPlaced = 0
        self.isLoggedIn = false
    }
    
    func handleOrderAction(action:CustomerOrderAction, order:Order){
        print(action, "performed")
        switch action {
        case CustomerOrderAction.place:
            self.placeOrder(order:order)
        case CustomerOrderAction.cancel:
            self.cancelOrder()
            
        }
    }
    
   private func placeOrder(order:Order){
        print(self.name, "created an order")
        self.orders.append(order)
        self.numberOfOrdersPlaced += 1
        //FInd the order and run some comandds on it
    }
  private func cancelOrder(){
        print(self.name, "canceled an order")
        self.numberOfOrdersPlaced += 1
    }
    func login()-> Result{
        do {
            self.isLoggedIn = true
            print("logging in", self.isLoggedIn)
            try self.modelContext?.save()
            return .success
        }
        
        catch {
            print(error)
            print("Could not login \(self.name)")
            return .failure
            
        }
        
    }}
    
    
