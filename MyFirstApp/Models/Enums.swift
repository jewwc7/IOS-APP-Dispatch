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

/////////////////////////////////UI
struct LabelAndSystemImage {
    var text: String
    var image: String
}

////////////////////////////////////Errors
struct BaseError: Error {
    var type: BaseErrorType
    var message: String
}

enum BaseErrorType {
    case ValidationError
    case DeveloperError
}
