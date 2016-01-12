//
//  API.swift
//  Peach
//
//  Created by Stephen Radford on 10/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Alamofire

enum API: URLRequestConvertible {
    
    // MARK: - Cases
    
    case Authenticate(String, String)
    case Activity
    case Connections
    case Stream(String)
    case CreatePost([String:AnyObject]?)
    
    // MARK: - URLRequestConvertible
    
    static let base = "https://v1.peachapi.com"
    
    var method: Alamofire.Method {
        switch self {
            case .Authenticate, .CreatePost:
                return .POST
            default:
                return .GET
        }
    }
    
    var path: String {
        switch self {
            case .Authenticate:
                return "/login"
            case .Activity:
                return "/stream/activity"
            case .Connections:
                return "/connections"
            case .Stream(let id):
                return "/stream/id/\(id)"
            case .CreatePost:
                return "/post"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
    
        let URL = NSURL(string: API.base)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let token = Peach.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
            case .Authenticate(let email, let password):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["email": email, "password": password]).0
            case .CreatePost(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
        }
        
    }
    
}