//
//  AppURL.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import UIKit

class AppURL {
    
    // GET METHODS
    static func getJobs(contains: String) -> String {
        return "http://api.dataatwork.org/v1/jobs/autocomplete?contains=\(contains)"
    }
    
    static func getJobs(beginsWith: String) -> String {
        return "http://api.dataatwork.org/v1/jobs/autocomplete?begins_with=\(beginsWith)"
    }
    
}
