//
//  NetworkUtils.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import Foundation

class NetworkUtils: NSObject {

    static let shared = NetworkUtils()
    fileprivate var timeout: TimeInterval = 60
    fileprivate var defaultHeader: [String: String]? = [:]
    fileprivate let queue = OperationQueue()

    private override init() {
        queue.name = "studio4"
        queue.maxConcurrentOperationCount = 1
    }

    // MARK: - Base Request
    public func request(url: String, method: RequestType, param: Data?, header: [String: String]?, taskId: String?, completion:(@escaping(Int, Data) -> Void), fail: (@escaping (ModelError) -> Void)) {

        guard let stringUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: stringUrl) else {
            print("Error: cannot create URL")
            let error = ModelError.urlError
            fail(error)
            return
        }

        var urlRequest = URLRequest(url: url)

        switch method {
        case RequestType.requestTypeGet:
            urlRequest.httpMethod = "GET"
        case RequestType.requestTypePost:
            urlRequest.httpMethod = "POST"
        case RequestType.requestTypePut:
            urlRequest.httpMethod = "PUT"
        case RequestType.requestTypeDelete:
            urlRequest.httpMethod = "DELETE"
        }

        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        urlRequest.allHTTPHeaderFields = headers

        if let defaultHeader = defaultHeader {
            for(key, value) in defaultHeader {
                urlRequest .setValue(value, forHTTPHeaderField: key)
            }
        }

        if let headers = header {
            for (key, value) in headers {
                urlRequest .setValue(value, forHTTPHeaderField: key)
            }
        }

        if let bodyData = param {
            urlRequest.httpBody = bodyData
        }

        urlRequest.timeoutInterval = timeout

        urlRequest.cachePolicy = .reloadIgnoringCacheData

        let session = URLSession.shared

        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("error calling API: \(error)")
                fail(ModelError.serviceError)
                return
            }

            guard let responseData = data else {
                print("Error: did not receive data")
                fail(ModelError.objectSericalization)
                return
            }

            //response code
            guard let httpResponse = response as? HTTPURLResponse else {
                fail(ModelError.unknown)
                return
            }
            
            print("API: \(url) - http status code : \(httpResponse.statusCode)")
            completion(httpResponse.statusCode, responseData)
        }

        if  taskId != nil {
            queue.addOperation {
                task.resume()
            }
        } else {
            task.resume()
        }

    }

    // MARK: - Support Method
    public func setDefaultHeader(_ header: [String: String]? ) {
        defaultHeader = header
    }

    public func cancellAllOperation() {
        queue.cancelAllOperations()
    }

    public func setTimeOut(_ time: TimeInterval) {
        timeout = time
    }

    // MARK: - Upload Image
    func uploadImageRequest(url: String, method: RequestType = .requestTypePost, params: [String: Any] = [:], listData: [String: [(String, String, Data)]] = [:], files: [String: (String, URL)] = [:], header: [String: String]?, taskId: String?, completion:(@escaping(Int, Data) -> Void), fail: (@escaping (ModelError) -> Void)) {
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            let error = ModelError.urlError
            fail(error)
            return
        }

        var urlRequest = URLRequest(url: url)

        switch method {
        case RequestType.requestTypeGet:
            urlRequest.httpMethod = "GET"
        case RequestType.requestTypePost:
            urlRequest.httpMethod = "POST"
        case RequestType.requestTypePut:
            urlRequest.httpMethod = "PUT"
        case RequestType.requestTypeDelete:
            urlRequest.httpMethod = "DELETE"
        }

        if let defaultHeader = defaultHeader {
            for(key, value) in defaultHeader {
                urlRequest .setValue(value, forHTTPHeaderField: key)
            }
        }

        if let headers = header {
            for (key, value) in headers {
                urlRequest .setValue(value, forHTTPHeaderField: key)
            }
        }

        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.setValue("multipart/form-data; boundary=\(NetworkUtils.boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = NetworkUtils.multiPartFormData(boundary: NetworkUtils.boundary, params: params, listData: listData, files: files)

        urlRequest.timeoutInterval = timeout

        urlRequest.cachePolicy = .reloadIgnoringCacheData

        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("error calling API: \(error)")
                fail(ModelError.serviceError)
                return
            }

            guard let responseData = data else {
                print("Error: did not receive data")
                fail(ModelError.objectSericalization)
                return
            }

            //response code
            guard let httpResponse = response as? HTTPURLResponse else {
                fail(ModelError.unknown)
                return
            }
            
            print("http status code : \(httpResponse.statusCode)")
            completion(httpResponse.statusCode, responseData)
        }

        if  taskId != nil {
            queue.addOperation {
                task.resume()
            }
        } else {
            task.resume()
        }
    }

    class func multiPartFormData(boundary: String, params: [String: Any], listData: [String: [(String, String, Data)]], files: [String: (String, URL)]) -> Data {
        var data = Data()
        for param in params {
            if let array = param.value as? [Any] {
                array.forEach {
                    if let data1 = "--\(boundary)\r\n".data(using: .utf8),
                        let data2 = "Content-Disposition: form-data; name=\"\(param.key)\"\r\n\r\n".data(using: .utf8),
                        let data3 = "\($0)\r\n".data(using: .utf8) {
                        data.append(data1)
                        data.append(data2)
                        data.append(data3)
                    }
                }
            } else {
                if let data1 = "--\(boundary)\r\n".data(using: .utf8),
                    let data2 = "Content-Disposition: form-data; name=\"\(param.key)\"\r\n\r\n".data(using: .utf8),
                    let data3 = "\(param.value)\r\n".data(using: .utf8) {
                    data.append(data1)
                    data.append(data2)
                    data.append(data3)
                }
            }
        }
        for dataInfo in listData {
            let key = dataInfo.key
            let array = dataInfo.value
            for value in array {
                let mimeType = value.0
                let name = value.1
                let fileData = value.2
                
                if let data1 = "--\(boundary)\r\n".data(using: .utf8),
                    let data2 = "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(name)\"\r\n".data(using: .utf8),
                    let data3 = "Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8),
                    let data4 = "\r\n".data(using: .utf8) {
                    data.append(data1)
                    data.append(data2)
                    data.append(data3)
                    data.append(fileData)
                    data.append(data4)
                }
            }
        }
        for file in files {
            do {
                let key = file.key
                let mimeType = file.value.0
                let url = file.value.1
                let fileData = try Data(contentsOf: url)
                if let data1 = "--\(boundary)\r\n".data(using: .utf8),
                    let data2 = "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(url.lastPathComponent)\"\r\n".data(using: .utf8),
                    let data3 = "Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8),
                    let data4 = "\r\n".data(using: .utf8) {
                    data.append(data1)
                    data.append(data2)
                    data.append(data3)
                    data.append(fileData)
                    data.append(data4)
                }
            } catch { }
        }
            
        if let boundaryData = "--\(boundary)--\r\n".data(using: .utf8) {
            data.append(boundaryData)
        }

        return data
    }

    class var boundary: String {
        return "Jimoful\(Int(Date().timeIntervalSince1970))"
    }
}
