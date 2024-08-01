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
@Model
class Route {
    // Properties
    var id: String?
//    var orders: [Order]
    var status: String?//RouteStatus
    
    
    // Initializer
    init(
       // orders: [Order] = []
    ) {
        self.id = UUID().uuidString
    //    self.orders = []
        self.status = "Inactive"//RouteStatus.inactive
    }
    
    
//    func handleRouteStatusChange(action:RouteStatus){
//        if action == RouteStatus.active && self.orders.count > 1{
//          print("Can activate route, there aren't any order in the cart")
//        }else{
//            
//        }
//      
//    }
    
  }
    
    
