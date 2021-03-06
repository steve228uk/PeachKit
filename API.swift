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
    case MarkActivityRead
    case Connections
    case Explore
    case Stream(String)
    case CreatePost([String:AnyObject]?)
    case MarkStreamRead(String)
    case FriendRequests
    case AcceptFriendRequest(String)
    case DeclineFriendRequest(String)
    case IgnoreFriendRequest(String)
    case LikePost(String)
    case UnlikePost(String)
    
    // MARK: - URLRequestConvertible
    
    static let base = "https://v1.peachapi.com"
    
    var method: Alamofire.Method {
        switch self {
            case .Authenticate, .CreatePost, .LikePost:
                return .POST
            case .MarkStreamRead, .MarkActivityRead, .AcceptFriendRequest, .DeclineFriendRequest, .IgnoreFriendRequest:
                return .PUT
            case .UnlikePost:
                return .DELETE
            default:
                return .GET
        }
    }
    
    var path: String {
        switch self {
            case .Authenticate:
                return "/login"
            case .Activity:
                return "/activity"
            case .MarkActivityRead:
                return "/activity/read"
            case .Connections:
                return "/connections"
            case .Explore:
                return "/connections/explore"
            case .Stream(let id):
                return "/stream/id/\(id)"
            case .MarkStreamRead(let id):
                return "/stream/id/\(id)/read"
            case .CreatePost:
                return "/post"
            case .FriendRequests:
                return "/connections/requests/inbound"
            case .AcceptFriendRequest(let id):
                return "/friend-request/\(id)/accept"
            case .DeclineFriendRequest(let id):
                return "/friend-request/\(id)/decline"
            case .IgnoreFriendRequest(let id):
                return "/friend-request/\(id)/ignore"
            case .LikePost:
                return "/like"
            case .UnlikePost(let id):
                return "/like/postID/\(id)"
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
            case .LikePost(let id):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["postId": id]).0
            default:
                return mutableURLRequest
        }
        
    }
    
}