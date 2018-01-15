//
//  HttpUtil.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 15/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import Alamofire

class HttpUtil: NSObject {
    static var cookies:String = ""
    static let X_API_Client_ID:String = "12D8"
    
    static func httpDelete(url: String, completionHandler: @escaping (DataResponse<Any>) -> () = { _ in }) {
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: ["X-API-Client-ID":X_API_Client_ID]).responseJSON { (response) in
            storeCookies(response: response)
            completionHandler(response)
        }
    }
    
    static func httpPost(url: String, parameters: Parameters = [:], completionHandler: @escaping (DataResponse<Any>) -> () = { _ in }) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Cookie":cookies,"X-API-Client-ID":X_API_Client_ID]).responseJSON { (response) in
            storeCookies(response: response)
            completionHandler(response)
        }
    }
    
    static func httpGet(url: String, parameters: Parameters = [:], completionHandler: @escaping (DataResponse<Any>) -> () = { _ in }) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: ["Cookie":cookies,"X-API-Client-ID":X_API_Client_ID]).responseJSON { (response) in
            storeCookies(response: response)
            completionHandler(response)
        }
    }
    
    static func storeCookies(response: DataResponse<Any>) {
        let cookies_new = response.response?.allHeaderFields["Set-Cookie"] as? String ?? ""
        if cookies_new != "" {
            cookies = cookies_new
        }
    }
}
