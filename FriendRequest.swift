//
//  Request.swift
//  Peach
//
//  Created by Stephen Radford on 14/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public struct FriendRequest {
    
    /// ID of the friend request
    public var id: String?
    
    /// Stream releated to the friend request
    public var stream: Stream?
    
    /**
     Accept the friend request
     
     - parameter callback: Optional callback
     */
    public func accept(callback: ((NSError?) -> Void)?) {
        if let requestID = id {
            Alamofire.request(API.AcceptFriendRequest(requestID))
                .responseJSON { response in
                    callback?(response.result.error)
                }
        }
    }
    
    /**
     Accept the friend request
     */
    public func accept() {
        accept(nil)
    }
    
    /**
     Decline the friend request
     
     - parameter callback: Optional callback
     */
    public func decline(callback: ((NSError?) -> Void)?) {
        if let requestID = id {
            Alamofire.request(API.DeclineFriendRequest(requestID))
                .responseJSON { response in
                    callback?(response.result.error)
            }
        }
    }
    
    /**
     Decline the friend request
     */
    public func decline() {
        decline(nil)
    }
    
    /**
     Ignore the friend request
     
     - parameter callback: Optional callback
     */
    public func ignore(callback: ((NSError?) -> Void)?) {
        if let requestID = id {
            Alamofire.request(API.IgnoreFriendRequest(requestID))
                .responseJSON { response in
                    callback?(response.result.error)
            }
        }
    }
    
    /**
     Ignore the friend request
     */
    public func ignore() {
        ignore(nil)
    }
    
}

extension Peach {
    
    /**
     Fetch a list of friend requests
     
     - parameter callback: Callback with array of requests and optional NSError
     */
    public class func getFriendRequests(callback: ([FriendRequest], NSError?) -> Void) {
        
        Alamofire.request(API.FriendRequests)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let data = json["data"].dictionary {
                            if let rawRequests = data["inboundFriendRequests"]?.array {
                                let requests: [FriendRequest] = rawRequests.map {
                                    var request = FriendRequest()
                                    request.id = $0["id"].string
                                    request.stream = self.parseStream($0["stream"])
                                    return request
                                }
                                callback(requests, response.result.error)
                            }
                        }
                    }
                }
                
                callback([], response.result.error)
            }
        
    }
    
}