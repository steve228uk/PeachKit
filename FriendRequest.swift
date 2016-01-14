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
                    let json = JSON(response.result.value!)
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
                
                callback([], response.result.error)
            }
        
    }
    
}