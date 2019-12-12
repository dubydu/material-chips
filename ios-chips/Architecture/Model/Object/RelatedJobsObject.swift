//
//  RelatedJobsObject.swift
//  ios-chips
//
//  Created by DU on 12/12/19.
//

import UIKit
import Foundation

// MARK: - RelatedJobs
class RelatedJobsObject: Codable {
    let relatedJobTitles: [RelatedJobTitleObject]?

    enum CodingKeys: String, CodingKey {
        case relatedJobTitles = "related_job_titles"
    }

    init(relatedJobTitles: [RelatedJobTitleObject]?) {
        self.relatedJobTitles = relatedJobTitles
    }
}

// MARK: - RelatedJobTitle
class RelatedJobTitleObject: Codable {
    let uuid, title, parentUUID: String?

    enum CodingKeys: String, CodingKey {
        case uuid, title
        case parentUUID = "parent_uuid"
    }

    init(uuid: String?, title: String?, parentUUID: String?) {
        self.uuid = uuid
        self.title = title
        self.parentUUID = parentUUID
    }
    
    func trimTitle() -> String? {
        calculateWidthFont(string: self.title)
    }
    
    func calculateWidthFont(string: String?) -> String? {
        guard let string = string else { return nil }
        let stringBounding = string.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        var newString = string
        
        if stringBounding.width > (UIScreen.main.bounds.width - 65) {
            newString = "\(newString.dropLast(15))" + "..."
            return calculateWidthFont(string: newString)
        }
        return newString
    }
}
