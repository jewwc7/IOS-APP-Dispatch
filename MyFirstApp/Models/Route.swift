//
//  Route.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/31/24.
//

import Foundation

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

enum RouteStatus {
    case active
    case inactive
}


//when adding a new one I need to add default values
// these are run in migrations,
// will get error if default values missing https://forums.developer.apple.com/forums/thread/746577
//Not in use
@Model
class Route {
    // Properties
    var id: String?
//    var orders: [Order]
    var status: String?//RouteStatus
    var driver: Driver?
    var orders = [Order]()
    var startDate = Date()
    
    // Initializer
    init(
      orders: [Order] = [],
      startDate: Date = Date(),
      driver:Driver? = nil
    ) {
        self.id = UUID().uuidString
        self.orders = []
        self.driver = driver
        self.status = "Inactive"//RouteStatus.inactive
        self.orders = orders
        self.startDate = startDate
    }
    
    
    func addOrder(order:Order){
        self.orders.append(order)
        do {
            try self.modelContext?.save()
        }catch{
            print("Couldnt add order to route \(self.id)", error)
        }
    }
  }
    
    
