//
//  Helpers.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

import Foundation

import Foundation

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
