//
//  JobsObject.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import Foundation
import UIKit

class JobsObject: Codable {
    let uuid, suggestion, normalizedJobTitle, parentUUID: String?

    enum CodingKeys: String, CodingKey {
        case uuid, suggestion
        case normalizedJobTitle = "normalized_job_title"
        case parentUUID = "parent_uuid"
    }

    init(uuid: String?, suggestion: String?, normalizedJobTitle: String?, parentUUID: String?) {
        self.uuid = uuid
        self.suggestion = suggestion
        self.normalizedJobTitle = normalizedJobTitle
        self.parentUUID = parentUUID
    }
    
    func trimSuggestion() -> String? {
        calculateWidthFont(string: self.suggestion)
    }
    
    func calculateWidthFont(string: String?) -> String? {
        guard let string = string else { return nil }
        let stringBounding = string.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        var newString = string
        
        if stringBounding.width > (UIScreen.main.bounds.width - 55) {
            newString = "\(newString.dropLast(15))" + "..."
            return calculateWidthFont(string: newString)
        }
        return newString
    }
}
