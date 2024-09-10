//
//  dummyData.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/9/24.
//

import Foundation

let namesDictionary: [String: [String]] = [
    "driver": [
        "Paul Wall",
        "John Doe",
        "Jane Smith",
        "Chris Evans",
        "Emma Watson",
        "Robert Downey",
        "Scarlett Johansson",
        "Tom Holland"
    ],
    "customer": [
        "Mike Jones",
        "Alice Johnson",
        "Bob Brown",
        "Bruce Wayne",
        "Clark Kent",
        "Diana Prince",
        "Barry Allen",
        "Hal Jordan"
    ]
]

let addressesDictionary: [String: [String]] = [
    "pickupStreet": ["1234 Main St", "4321 Elm St", "5678 Oak St"],
    "pickupCityStateZip": ["Kansas City, MO 64127", "Springfield, IL 62704", "Austin, TX 73301"],
    "dropoffStreet": ["6789 Broadway St", "8765 Pine St", "9101 Maple St"],
    "dropoffCityStateZip": ["Kansas City, MO 64111", "Springfield, IL 62704", "Austin, TX 73301"]
]

let organizationDictionary: [String: [String]] = [
    "organization": [
        "Swishahouse",
        "Diamond Boys",
        "Tech Corp",
        "Innovate LLC",
        "Tech Innovators",
        "Green Solutions",
        "Future Enterprises",
        "Global Ventures",
        "Creative Labs",
        "NextGen Technologies",
        "Pioneer Services",
        "Elite Solutions",
        "Dynamic Industries",
        "Visionary Holdings"
    ]
]
// Function to randomly pick a name based on the role
func pickRandomElement(for key: String, from dictionary: [String: [String]]) -> String? {
    guard let elements = dictionary[key] else {
        return nil
    }
    return elements.randomElement()
}

func createPickupDropoffData(type: StopType? = .pickup) -> [String: String] {
    let streetAddress = pickRandomElement(for: type == .pickup ? "pickupStreet" : "dropoffStreet", from: addressesDictionary) ?? "Default street address"
    let cityStateZip = pickRandomElement(for: type == .pickup ? "pickupCityStateZip" : "dropoffCityStateZip", from: addressesDictionary) ?? "Default Pickup City, State, Zip"
    let contactName = pickRandomElement(for: "customer", from: namesDictionary) ?? "Default Contact"
    let organization = pickRandomElement(for: "organization", from: organizationDictionary) ?? "Default Org"
    return [
        "streetAddress": streetAddress,
        "cityStateZip": cityStateZip,
        "contactName": contactName,
        "organization": organization
    ]
}

func randomPay() -> Double {
    return Double.random(in: 1.00 ... 100.90)
}
