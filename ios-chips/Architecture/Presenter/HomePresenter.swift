//
//  HomePresenter.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import Foundation

class HomePresenter: BasePresenter {
    weak var delegate: HomeDelegate?
    
    func getListJobs(beginsWith: String) {
        NetworkUtils.shared.request(url: AppURL.getJobs(beginsWith: beginsWith), method: .requestTypeGet, param: nil, header: nil, taskId: nil, completion: { [weak self] (statusCode, data) in
            guard let `self` = self else { return }
            let response = self.processResponseData(statusCode: statusCode, data: data, objectConvert: [JobsObject].self)
            let errorMessage = response.errorMessage
            let responseData = response.responseData
            
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                DispatchQueue.main.async {
                    self.delegate?.getJobsListFailed(message: errorMessage)
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate?.getJobsListSuccessed(data: responseData)
                }
            }
            
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.delegate?.getJobsListFailed(message: error.localizedDescription)
            }
        }
    }
}
