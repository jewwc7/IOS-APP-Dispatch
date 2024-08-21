//
//  Dropoff.swift
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
class Dropoff {
    // Properties
    var id: String
    var order: Order
    var address: String
    var cityStateZip: String
    var locationId: UUID
    var phoneNumber: String
    var contactName: String
    var company: String

    init(
        order: Order,
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
        self.order = order
    }
    
    func fullAddress() -> String {
        return address + ", " + cityStateZip
    }
}
