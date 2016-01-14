//
//  Activity.swift
//  Peach
//
//  Created by Stephen Radford on 10/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public struct Activity {
    
    /// The type of activity. Currently this is either Like or Comment.
    public var type: ActivityType?
    
    /// The stream of the person who completed the activity.
    public var authorStream: Stream?
    
    /// The ID of the post the action is relating to.
    public var postID: String?
    
    /// The message of the post the activity is related to.
    public var postMessage: [Message] = []
    
}

public enum ActivityType {
    case Like
    case Comment
}

extension Peach {
    
    /**
     Fetch the activity feed
     
     - parameter callback: Callback with array of activities and an optional NSError
     */
    public class func getActivityFeed(callback: ([Activity], NSError?) -> Void) {
        Alamofire.request(API.Activity)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let data = json["data"].dictionary {
                            if let items = data["activityItems"]?.array {
                                let activity: [Activity] = items.map(parseActivity)
                                callback(activity, response.result.error)
                                return
                            }
                        }
                    }
                }
                
                callback([], response.result.error)
            }
    }
    
    /**
     Map raw JSON to `activity`
     
     - parameter json: The raw JSON to parse
     
     - returns: The mapped activity
     */
    internal class func parseActivity(json: JSON) -> Activity {
        var activity = Activity()
        
        if let type = json["type"].string {
            switch type {
                case "comment":
                    activity.type = .Comment
                default:
                    activity.type = .Like
            }
        }
        
        if let body = json["body"].dictionary {
            activity.postID = body["postID"]?.string
            if let stream = body["authorStream"] {
                activity.authorStream = parseStream(stream)
            }
            if let message = body["postMessage"]?.array {
                activity.postMessage = message.map(parseMessage)
            }
        }
        
        return activity
    }
    
}