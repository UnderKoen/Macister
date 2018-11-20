//
//  HttpUtil.swift
//  Macister
//
//  Created by Koen van Staveren on 15/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import Alamofire

class HttpUtil: NSObject {
    static var cookies: String = ""
    static let X_API_Client_ID: String = "12D8"

    static func httpDelete(url: String, completionHandler: @escaping (DataResponse<Any>) -> () = { _ in
    }) {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.SessionManager.default.request(url, method: .delete, encoding: JSONEncoding.default, headers: ["X-API-Client-ID": X_API_Client_ID]).responseJSON { (response) in
            storeCookies(response: response)
            completionHandler(response)
        }
    }

    static func httpPost(url: String, parameters: Parameters = [:], completionHandler: @escaping (DataResponse<Any>) -> () = { _ in
    }) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Cookie": cookies, "X-API-Client-ID": X_API_Client_ID]).responseJSON { (response) in
            storeCookies(response: response)
            completionHandler(response)
        }
    }

    static func httpPut(url: String, parameters: Parameters = [:], completionHandler: @escaping (DataResponse<Any>) -> () = { _ in
    }) {
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: ["Cookie": cookies, "X-API-Client-ID": X_API_Client_ID]).responseJSON { (response) in
            storeCookies(response: response)
            completionHandler(response)
        }
    }

    static func httpGet(url: String, parameters: Parameters = [:], completionHandler: @escaping (DataResponse<Any>) -> () = { _ in
    }) {
        Alamofire.SessionManager.default.requestWithoutCache(url, method: .get, parameters: parameters, headers: ["Cookie": cookies, "X-API-Client-ID": X_API_Client_ID]).responseJSON { (response) in
            storeCookies(response: response)
            completionHandler(response)
        }
    }

    static func httpGetFile(url: String, fileName: String, location: URL = FileUtil.getApplicationFolder(), override: Bool = true, parameters: Parameters = [:], completionHandler: @escaping (DownloadResponse<Data>) -> () = { _ in
    }, progressHandler: @escaping (Progress) -> () = { _ in
    }) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = location
            var fileURL = documentsURL.appendingPathComponent(fileName)

            if (!override) {
                var t = fileName.split(separator: ".")
                let fileAft = t.removeLast()
                let filePre = t.joined(separator: ".")

                var i = 1
                while FileManager.default.fileExists(atPath: fileURL.path) {
                    fileURL = documentsURL.appendingPathComponent("\(filePre) (\(i)).\(fileAft)")
                    i += 1
                }
            }
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(url, method: .get, parameters: parameters, headers: ["Cookie": cookies, "X-API-Client-ID": X_API_Client_ID], to: destination).responseData { (response) in
            completionHandler(response)
        }.downloadProgress { (progress) in
            progressHandler(progress)
        }
    }

    static func storeCookies(response: DataResponse<Any>) {
        let cookies_new = response.response?.allHeaderFields["Set-Cookie"] as? String ?? ""
        if cookies_new != "" {
            cookies = cookies_new
        }
    }
}

extension Alamofire.SessionManager {
    @discardableResult
    open func requestWithoutCache(
            _ url: URLConvertible,
            method: HTTPMethod = .get,
            parameters: Parameters? = nil,
            encoding: ParameterEncoding = URLEncoding.default,
            headers: HTTPHeaders? = nil)// also you can add URLRequest.CachePolicy here as parameter
                    -> DataRequest {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            // TODO: find a better way to handle error
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}
