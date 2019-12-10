//
//  BasePresenter.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import Foundation
import UIKit

protocol BasePresenterProtocol: class {
    func processResponseData<T: Codable>(statusCode: Int, data: Data, objectConvert: T.Type) -> (errorMessage: String?, responseData: T?)
    func addUserToken(urlString: String) -> String
}

class BasePresenter: NSObject, BasePresenterProtocol {

    public func processResponseData<T: Codable>(statusCode: Int, data: Data, objectConvert: T.Type) -> (errorMessage: String?, responseData: T?) {
        if String(statusCode).hasPrefix("2") {  //success status code : 2xx
            //success
            let decoder = JSONDecoder()
            do {
                let responseData = try decoder.decode(objectConvert, from: data)
                return (nil, responseData)
            } catch let error {
                print(error)
                let errorMessage = ModelError.parseJson.localizedDescription
                return (errorMessage, nil)
            }
        } else {
            //fail
            let errorMessage = self.getMessageError(data: data)
            return (errorMessage, nil)
        }
    }

    public func addUserToken(urlString: String) -> String {
        // guard let userToken = UserManagement.getUserToken() else { return urlString }
        // return "\(urlString)?token=\(userToken)"
        return ""
    }

    public func getMessageError(data: Data) -> String {
        var errorMessage = "error"
        let decoder = JSONDecoder()
        do {
             let errorObj = try decoder.decode(ErrorObject.self, from: data)
             //get messages in array errors
            if let errors = errorObj.errors, errors.count > 0 {
                let error = errors[0]
                errorMessage = error.message ?? "error"
            } else
                if let errMessage = errorObj.message, !errMessage.isEmpty {
                    errorMessage = errMessage
                }
            return errorMessage

        } catch let error {
            print(error)
            errorMessage = ModelError.parseJson.localizedDescription
            return errorMessage
        }
    }
}
