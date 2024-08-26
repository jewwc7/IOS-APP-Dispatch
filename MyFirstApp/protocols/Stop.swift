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
    var stopType: StopType.RawValue { get }
    var deliveredAt: Date? { get set }
    // var dueAt: Date? { get set }
}

enum StopType: String, Codable {
    case pickup
    case dropoff
}
