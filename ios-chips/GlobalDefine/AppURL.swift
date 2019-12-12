//
//  AppURL.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import UIKit

class AppURL {
    
    static let baseURL = "http://api.dataatwork.org/"
    
    // GET METHODS
    static func getJobs(contains: String) -> String {
        return "\(baseURL)v1/jobs/autocomplete?contains=\(contains)"
    }
    
    static func getJobs(beginsWith: String) -> String {
        return "\(baseURL)v1/jobs/autocomplete?begins_with=\(beginsWith)"
    }
    
    static func getRelatedJobs(uuid: String) -> String {
        return "\(baseURL)v1/jobs/\(uuid)/related_jobs"
    }
}
