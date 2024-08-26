//
//  Pickup.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/20/24.
//

import Combine
import CoreData
import Foundation
import SwiftData
import SwiftUI

@Model
class Pickup: Stop {
    // Properties
    var id: String
    var order: Order?
    var address: String
    var cityStateZip: String
    var locationId: UUID
    var phoneNumber: String
    var contactName: String
    var company: String
    var stopType: StopType.RawValue
    var deliveredAt: Date? = nil
    var fullAddress: String {
        return "\(address), \(cityStateZip)"
    }

    init(
        address: String,
        cityStateZip: String,
        locationId: UUID,
        phoneNumber: String,
        contactName: String,
        company: String
    ) { // 7 days from now or right now
        self.id = UUID().uuidString
        self.address = address
        self.cityStateZip = cityStateZip
        self.locationId = locationId
        self.phoneNumber = phoneNumber
        self.contactName = contactName
        self.company = company
        self.stopType = StopType.pickup.rawValue
        self.order = order
        self.deliveredAt = nil
    }
}
