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

enum OrderAction {
    case place
    case cancel
}
@Model
class Customer {
    // Properties
    var id: String?
    var name: String
    var numberOfOrdersPlaced: Int

    
    // Initializer
    init(
            name: String
    ) {
           self.id = UUID().uuidString
           self.name = name
           self.numberOfOrdersPlaced = 0
       }
    
    
    func handleOrderAction(action:OrderAction){
        print(action, "performed")
        switch action {
        case OrderAction.place:
            self.placeOrder()
        case OrderAction.cancel:
            self.cancelOrder()
        default:
            print("no action passed to handleOrderAction")
            return
        }
    }
    
    func placeOrder(){
        print(self.name, "created an order")
        self.numberOfOrdersPlaced += 1
        //FInd the order and run some comandds on it
    }
    func cancelOrder(){
        print(self.name, "canceled an order")
        self.numberOfOrdersPlaced += 1
    }
    
}


