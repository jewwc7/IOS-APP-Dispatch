//
//  Driver.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/1/24.
//



import SwiftData
import Foundation
import CoreData
//NSObject, NSFetchRequestResult, Identifiable

enum DriverOrderAction {
    case claim
    case release
}


//when adding a new one I need to add default values
// these are run in migrations,
// will get error if default values missing https://forums.developer.apple.com/forums/thread/746577
@Model
class Driver {
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
    
    func handleOrderAction(action:DriverOrderAction, order:Order){
        print(action, "performed")
        if order.status == OrderStatus.claimed || order.status == OrderStatus.canceled {
            print("order already claimed or canceled") // ErrorPop
        }
        switch action {
        case DriverOrderAction.claim:
            self.claimOrder(order:order)
        case DriverOrderAction.release:
            self.cancelOrder()
            
        }
    }
    
   private func claimOrder(order:Order){
        print(self.name, "claimed an order")
        self.orders.append(order)
        self.numberOfOrdersPlaced += 1
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
    
    
