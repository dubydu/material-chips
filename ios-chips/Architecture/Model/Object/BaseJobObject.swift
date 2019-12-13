//
//  BaseJobObject.swift
//  ios-chips
//
//  Created by DU on 12/12/19.
//

import UIKit
import Foundation

// MARK: - BaseJobObjectElement
class BaseJobObject: Codable {
    let uuid, title, normalizedJobTitle, parentUUID: String?
    let links: [BaseJobLinkObject]?

    enum CodingKeys: String, CodingKey {
        case uuid, title
        case normalizedJobTitle = "normalized_job_title"
        case parentUUID = "parent_uuid"
        case links
    }

    init(uuid: String?, title: String?, normalizedJobTitle: String?, parentUUID: String?, links: [BaseJobLinkObject]?) {
        self.uuid = uuid
        self.title = title
        self.normalizedJobTitle = normalizedJobTitle
        self.parentUUID = parentUUID
        self.links = links
    }
    
    func trimJobTitle() -> String? {
        calculateWidthFont(string: self.title)
    }
    
    func calculateWidthFont(string: String?) -> String? {
        guard let string = string else { return nil }
        let stringBounding = string.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        var newString = string
        
        if stringBounding.width > (UIScreen.main.bounds.width - 95) {
            newString = "\(newString.dropLast(13))" + "..."
            return calculateWidthFont(string: newString)
        }
        return newString
    }
}

// MARK: - Link
class BaseJobLinkObject: Codable {
    let rel, href: String?

    init(rel: String?, href: String?) {
        self.rel = rel
        self.href = href
    }
}
