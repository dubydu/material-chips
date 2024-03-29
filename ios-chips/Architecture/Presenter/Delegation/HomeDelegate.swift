//
//  HomeDelegate.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import Foundation

protocol HomeDelegate: NSObjectProtocol {
    func getAllJobsListSuccessed(data: [BaseJobObject]?)
    func getAllJobsListFailed(message: String)
    
    func getJobsListSuccessed(data: [JobsObject]?)
    func getJobsListFailed(message: String)
    
    func getRelatedJobsListSuccessed(data: RelatedJobsObject?)
    func getRelatedJobsListFailed(message: String)
}

extension HomeDelegate {
    public func getAllJobsListSuccessed(data: [BaseJobObject]?) { }
    public func getAllJobsListFailed(message: String) { }
    
    public func getJobsListSuccessed(data: [JobsObject]?) { }
    public func getJobsListFailed(message: String) { }
    
    public func getRelatedJobsListSuccessed(data: RelatedJobsObject?) { }
    public func getRelatedJobsListFailed(message: String) { }
}
