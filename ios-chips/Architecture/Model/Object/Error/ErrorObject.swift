//
//  ErrorObject.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import Foundation

class ErrorObject: NSObject, Codable {
    let message: String?
    let errors: [APIError]?

    init(message: String, errors: [APIError]) {
        self.message = message
        self.errors = errors
    }
}

class APIError: Codable {
    let field: String?
    let message: String?

    init(field: String, message: String) {
        self.field = field
        self.message = message
    }
}
