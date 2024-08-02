//
//  Enums.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/29/24.
//

import Foundation


enum Result {
    case success
    case failure
    case noResult
}

struct ResultWithMessage {
var result: Result
var message: String = ""
}
