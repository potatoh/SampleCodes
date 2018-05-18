//
//  Router.swift
//  Crush
//
//  Created by Sherif Ahmed on 1/07/17.
//  Copyright © 2017 dreidev. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    
    case getReceivedBottles
    
    static let baseURLString = "https://crushed.site/api"
    
    var method: HTTPMethod {
        switch self {
            
        case .getReceivedBottles:
            
            return .get
            
        }
    }
    
    var path: String {
        switch self {
        case .getReceivedBottles:
            return "/bottles/list-received/"
        }
    }
    
    //MARK:- URLRequestConvertible protocol methods
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        let token = KeychainWrapper.standard.string(forKey: "token")
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        if let token = token {
            urlRequest.addValue("Token " + token, forHTTPHeaderField: "Authorization")
        	}
   		return urlRequest     
	}
}




