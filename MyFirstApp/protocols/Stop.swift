//
//  Stop.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/23/24.
//

import Foundation

// Define the Stop protocol
protocol Stop {
    var id: String { get } // can only be read not modified
    var order: Order? { get set }
    var address: String { get set }
    var cityStateZip: String { get set }
    var locationId: UUID { get set }
    var phoneNumber: String { get set }
    var contactName: String { get set }
    var company: String { get set }
    var fullAddress: String { get }
}

// Define an enum to encapsulate Pickup and Dropoff
enum StopType {
    case pickup(Pickup)
    case dropoff(Dropoff)
}
