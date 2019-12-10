//
//  HomeDelegate.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import Foundation

protocol HomeDelegate: NSObjectProtocol {
    func getJobsListSuccessed(data: [JobsObject]?)
    func getJobsListFailed(message: String)
}

extension HomeDelegate {
    public func getJobsListSuccessed(data: [JobsObject]?) { }
    public func getJobsListFailed(message: String) { }
}
