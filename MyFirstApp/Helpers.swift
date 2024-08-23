//
//  Helpers.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

import CoreData
import Foundation
import SwiftData

func humanizeCamelCase(_ input: String) -> String {
    // Check if the input is a single uncapitalized word
    if input.range(of: "^[a-z]+$", options: .regularExpression) != nil {
        return input.prefix(1).uppercased() + input.dropFirst()
    }

    // Adjust the regular expression to capture the initial lowercase letters followed by an uppercase letter
    // and sequences of an uppercase letter followed by lowercase letters
    let pattern = "([a-z]+(?=[A-Z])|[A-Z][a-z]*)"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])

    let range = NSRange(location: 0, length: input.utf16.count)
    let matches = regex.matches(in: input, options: [], range: range)

    var words = matches.map { match -> String in
        let matchRange = Range(match.range, in: input)!
        return String(input[matchRange])
    }

    // Special handling to capitalize the first word if it starts with lowercase letters
    if let first = words.first, first.range(of: "^[a-z]+", options: .regularExpression) != nil {
        words[0] = first.prefix(1).uppercased() + first.dropFirst()
    }

    return words.joined(separator: " ")
}

func createOrder(driver: Driver? = nil, customer: Customer? = nil, pickup: Pickup? = nil, dropoff: Dropoff? = nil) -> Order {
    let finalPickup = pickup ?? Pickup(address: "1234 main st", cityStateZip: "Kansas City, MO 64127", locationId: UUID(), phoneNumber: "281-330-8004", contactName: "Mike Jones", company: "Swishahouse")
    let finaldropoff = dropoff ?? Dropoff(address: "6789 broadway st", cityStateZip: "Kansas City, MO 64111", locationId: UUID(), phoneNumber: "904-490-7777", contactName: "Johnny", company: "Diamond Boys")

    let order = Order(orderNumber: "123", pickupLocation: "1234 main st", pickupPhoneNumber: "281-330-8004", pickupContactName: "Mike Jones", pickupCompanyOrOrg: "Swishahouse", dropoffLocation: "6789 broadway st", dropoffPhoneNumber: "904-490-7777", dropoffContactName: "Johnny", dropoffCompanyOrOrg: "Diamond Boys", pay: 100, customer: customer ?? Customer(name: "John"), driver: driver, pickup: finalPickup, dropoff: finaldropoff)

    finalPickup.order = order
    finaldropoff.order = order
    return order
}

func isSameDay(first: Date, second: Date) -> Bool {
    return Calendar.current.isDate(first, equalTo: second, toGranularity: .day)
}

func onlyDate(date: Date) -> Date {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)

    // Create a new date from these components, effectively stripping the time
    if let strippedDate = calendar.date(from: dateComponents) {
        print("Original Date: \(date)")
        print("Date with Time Stripped: \(strippedDate)")
        return strippedDate
    } else {
        return date
    }
}

func convertDateToDateOnlyString(day: Date) -> String {
    let formatter1 = DateFormatter()
    formatter1.dateStyle = .short
    return formatter1.string(from: day)
}
