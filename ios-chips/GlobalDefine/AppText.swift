//
//  AppText.swift
//  ios-chips
//
//  Created by DU on 12/8/19.
//

import UIKit

struct AppText {
    // MARK: - MESSAGE COMMON
    static var messageNoInternet: String { return "MESSAGE_NO_INTERNET".localized }
    static var messageErrorURL: String {return "MESSAGE_ERROR_URL".localized }
    static var messageErrorUnknown: String {return "MESSAGE_ERROR_UNKNOWN".localized }
    static var messageErrorObjectSericalization: String {return "MESSAGE_ERROR_OBJECT_SERICALIZATION".localized }
    static var messageErrorParseJson: String {return "MESSAGE_ERROR_PARSE_JSON".localized }
    static var messageErrorCallService: String { return "MESSAGE_ERROR_CALL_SERVICE".localized }
    static var messageLoginFailed: String { return "MESSAGE_LOGIN_FAILED".localized }
    
    // MARK: - Tabbar
    static var home: String { return "TABBAR_HOME".localized }
    static var clouded: String { return "TABBAR_CLOUDED".localized }
    static var shared: String { return "TABBAR_SHARED".localized }
    static var saved: String { return "TABBAR_SAVED".localized }
}
