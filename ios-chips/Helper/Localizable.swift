//
//  Localizable.swift
//  ios-chips
//
//  Created by DU on 12/8/19.
//

import Foundation

let langIdentifier = "en"

extension String {

    var localized: String {
        return localizeString(langIdentifier)
    }

    func localizeString(_ lang: String? = "en") -> String {
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let bundle = Bundle(path: path) {
           return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
        return NSLocalizedString(self, comment: "")
    }

}
