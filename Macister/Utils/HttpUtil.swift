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
    static let X_API_Client_ID: String = "12D8"
    public static var auth: String = ""
    static var start = false
    
    static func getParameter(parameter: String, url: String) -> String {
        let pattern = "\(parameter)=(.+?)(?=$|&)"
        let regex = try! NSRegularExpression(pattern: pattern)
        let result = regex.firstMatch(in: url, range: NSRange(location: url.startIndex.encodedOffset, length: url.endIndex.encodedOffset))
        return regex.replacementString(for: result!, in: url, offset: 0, template: "$1")
    }
    
    private static func startF() {
        if start {
            return
        }
        start = true
        let delegate = Alamofire.SessionManager.default.delegate
        delegate.taskWillPerformHTTPRedirection = { (_, _, _, _) -> URLRequest? in
            return nil
        }
    }

    static func httpDelete(url: String) -> Future<DataResponse<Any>> {
        startF()
        URLCache.shared.removeAllCachedResponses()
        return Future { completion in
            Alamofire.SessionManager.default.request(url, method: .delete, encoding: JSONEncoding.default, headers: ["X-API-Client-ID": X_API_Client_ID, "Authorization":"Bearer \(auth)"]).responseJSON { (response) in
                completion(Result.success(response))
            }
        }
    }

    static func httpPost(url: String, parameters: Parameters = [:], headers: HTTPHeaders = [:]) -> Future<DataResponse<Any>> {
        startF()
        var head = headers
        head["Cookie"] = getCookies()
        head["X-API-Client-ID"] = X_API_Client_ID
        head["Authorization"] = "Bearer \(auth)"
        return Future { completion in
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: head).responseJSON { (response) in
                completion(Result.success(response))
            }
        }
    }

    static func httpPut(url: String, parameters: Parameters = [:]) -> Future<DataResponse<Any>> {
        startF()
        return Future { completion in
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: ["Cookie": getCookies(), "X-API-Client-ID": X_API_Client_ID, "Authorization":"Bearer \(auth)"]).responseJSON { (response) in
                completion(Result.success(response))
            }
        }
    }
    
    static func httpGet(url: String, parameters: Parameters = [:]) -> Future<DataResponse<Any>> {
        startF()
        return Future { completion in
            Alamofire.SessionManager.default.requestWithoutCache(url, method: .get, parameters: parameters, headers: ["Cookie": getCookies(), "X-API-Client-ID": X_API_Client_ID, "Authorization":"Bearer \(auth)"]).responseJSON { (response) in
                completion(Result.success(response))
            }
        }
    }

    static func httpGetFile(url: String, fileName: String, location: URL = FileUtil.getApplicationFolder(), override: Bool = true, parameters: Parameters = [:], progressHandler: @escaping (Progress) -> () = { _ in
    }) -> Future<DownloadResponse<Data>> {
        startF()
        return Future { completion in
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

            Alamofire.download(url, method: .get, parameters: parameters, headers: ["Cookie": getCookies(), "X-API-Client-ID": X_API_Client_ID, "Authorization":"Bearer \(auth)"], to: destination).responseData { (response) in
                completion(Result.success(response))
            }.downloadProgress { (progress) in
                progressHandler(progress)
            }
        }
    }

    static func getCookies() -> String {
        let storage = Alamofire.SessionManager.default.session.configuration.httpCookieStorage!
        return storage.cookies!.map { cookie in
            return "\(cookie.name)=\(cookie.value); "
            }.joined()
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
