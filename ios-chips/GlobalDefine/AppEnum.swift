//
//  AppEnum.swift
//  ios-chips
//
//  Created by DU on 12/8/19.
//

import UIKit

enum RequestType: Int {
    case requestTypeGet = 1, requestTypePost, requestTypePut, requestTypeDelete
}

enum ModelError: Int, Error {
    case urlError = 400
    case unknown  = 404
    case noInternet = 401
    case objectSericalization = 405
    case parseJson = 505
    case serviceError = 500

    var localizedDescription: String {
        switch self {
        case .urlError:
            return AppText.messageErrorURL
        case .unknown:
            return AppText.messageErrorUnknown
        case .noInternet:
            return AppText.messageNoInternet
        case .objectSericalization:
            return AppText.messageErrorObjectSericalization
        case .parseJson:
            return AppText.messageErrorParseJson
        case .serviceError:
            return AppText.messageErrorCallService
        }
    }
    var code: Int {
        return self.rawValue
    }
}

enum TabbarType: Int, CaseIterable {
    case home = 0
    case clouded
    case shared
    case saved
    
    var tabbarItems: (title: String, image: String, selectImage: String, rootViewController: UIViewController) {
        switch self {
        case .home:
            return (AppText.home, AppIcon.homeOutlined, AppIcon.homeFilled, HomeVC())
        case .clouded:
            return (AppText.clouded, AppIcon.cloudedOutlined, AppIcon.cloudedFilled, CloudedVC())
        case .shared:
            return (AppText.shared, AppIcon.sharedOutlined, AppIcon.sharedFilled, SharedVC())
        case .saved:
            return (AppText.saved, AppIcon.savedOutlined, AppIcon.savedFilled, SavedVC())
        }
    }
}
