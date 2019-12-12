//
//  ExpertiseObject.swift
//  ios-chips
//
//  Created by DU on 12/12/19.
//

import Foundation
import UIKit

class ExpertiseObject {
    var jobTitle: String?
    var ratingValue: Double?
    var comment: String?
    
    init(jobTitle: String?, ratingValue: Double?, comment: String?) {
        self.jobTitle = jobTitle
        self.ratingValue = ratingValue
        self.comment = comment
    }
    
    func trimJobTitle() -> String? {
        calculateWidthFont(string: self.jobTitle)
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
