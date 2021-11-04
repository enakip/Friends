//
//  NetworkLayer.swift
//  
//
//  Created by Emiray Nakip on 4.08.2021.
//

import Foundation
import Alamofire

struct NetworkLayer {
    
    static let shared = NetworkLayer()
    let session: Session
    
    init() {
        self.session = Session()
    }
    
    static func request(_ convertible: URLRequestConvertible) -> DataRequest {
        shared.session.request(convertible).validate()
    }
    
}


