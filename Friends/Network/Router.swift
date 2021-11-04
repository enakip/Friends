//
//  Router.swift
//  
//
//  Created by Emiray Nakip on 4.08.2021.
//

import Foundation
import Alamofire

var jsonHeaders: HTTPHeaders = [
    "Content-Type": "application/x-www-form-urlencoded",
    "Connection": "keep-alive"
]

enum Router: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "https://randomuser.me/api/"
    }
    
   // case list
    case list(Parameters)
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return ""
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .list(let params):
            return params//["results":21]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        request.headers = jsonHeaders
        return try URLEncoding.default.encode(request, with: parameters)
    }
}


