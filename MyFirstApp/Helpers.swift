//
//  Helpers.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

import SwiftData
import Foundation
import CoreData


func humanizeCamelCase(_ input: String) -> String {
    // Create a regular expression to find capital letters
    let pattern = "([A-Z][a-z]*)"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    
    // Find matches in the input string
    let range = NSRange(location: 0, length: input.utf16.count)
    let matches = regex.matches(in: input, options: [], range: range)
    
    // Extract matched words and join them with spaces
    let words = matches.map { match -> String in
        let matchRange = Range(match.range, in: input)!
        return String(input[matchRange])
    }
    
    // Capitalize the first letter of each word and join them with spaces
    let capitalizedWords = words.map { word in
        word.prefix(1).uppercased() + word.dropFirst()
    }
    
    return capitalizedWords.joined(separator: " ")
}


func createOrder(driver:Driver? = nil, customer:Customer? = nil)->Order{
    return Order( orderNumber: "123", pickupLocation: "1234 main st", pickupPhoneNumber: "281-330-8004", pickupContactName: "Mike Jones", pickupCompanyOrOrg: "Swishahouse", dropoffLocation: "6789 broadway st", dropoffPhoneNumber: "904-490-7777", dropoffContactName: "Johnny", dropoffCompanyOrOrg: "Diamond Boys", pay: 100, customer: customer ?? Customer(name: "John"), driver:Driver(name: "Jack") )
    
}

func isSameDay(first:Date, second:Date)-> Bool{
    return Calendar.current.isDate(first, equalTo: second, toGranularity: .day)
}

func onlyDate(date:Date)->Date{
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)

    // Create a new date from these components, effectively stripping the time
    if let strippedDate = calendar.date(from: dateComponents) {
        print("Original Date: \(date)")
        print("Date with Time Stripped: \(strippedDate)")
        return strippedDate
    }else {
        return date
    }
    
}

func convertDateToDateOnlyString(day:Date)-> String{
    let formatter1 = DateFormatter()
    formatter1.dateStyle = .short
   return formatter1.string(from: day)
}
