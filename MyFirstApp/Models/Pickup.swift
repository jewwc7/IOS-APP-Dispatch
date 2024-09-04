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
class Pickup: BaseModel, Stop {
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
    var dueAt: Date
    var createdAt: Date
    var updatedAt: Date

    var fullAddress: String {
        return "\(address), \(cityStateZip)"
    }

    var fullAddressSpaced: String {
        return "\(address)\n\(cityStateZip)"
    }

    init(
        address: String,
        cityStateZip: String,
        locationId: UUID,
        phoneNumber: String,
        contactName: String,
        company: String,
        dueAt: Date
    ) { // 7 days from now or right now
        self.id = UUID().uuidString
        self.address = address
        self.cityStateZip = cityStateZip
        self.locationId = locationId
        self.phoneNumber = phoneNumber
        self.contactName = contactName
        self.company = company
        self.dueAt = dueAt
        self.stopType = StopType.pickup.rawValue
        self.deliveredAt = nil
        self.createdAt = .now
        self.updatedAt = .now
        self.order = order
    }

    func validateFields(
    ) throws {
        let fields = [ // think it's ok without city and location ID? Not all the locations have city
            ("Pickup address", address),
            ("Pickup phone number", phoneNumber),
            ("Pickup contact name", contactName),
            ("Pickup company or organization", company),
        ]

        for (_fieldName, fieldValue) in fields {
            if fieldValue.isEmpty {
                throw BaseError(type: .ValidationError, message: "Pickup has empty fields")
            }
        }

        // return ResultWithMessage(result: .success, message: "success") // .failure(.emptyField(message: "\(fieldName) is empty"))
    }
}
