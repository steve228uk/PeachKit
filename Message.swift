//
//  Message.swift
//  Peach
//
//  Created by Stephen Radford on 10/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Message {
    
    /// What type of message is this?
    public var type: MessageType?
    
    /// Text releated to the message
    public var text: String?
    
    /// Source URL of any image
    public var src: String?
    
    /// Width of any image
    public var width: Int?
    
    /// Height of any image
    public var height: Int?
    
    internal var dictionary: [String:String] {
        get {
            return [
                "type": "text",
                "text": (text != nil) ? text! : ""
            ]
        }
    }
    
    public init() { }
    
}

public enum MessageType {
    
    case Text
    case GIF
    case Image
    case Shout
    case Video
    case Drawing
    
}

extension Peach {
    
    /**
     Parse messages from a post
     
     - parameter json: The raw JSON
     
     - returns: The parsed message
     */
    internal class func parseMessage(json: JSON) -> Message {
        var msg = Message()
        
        if let type = json["type"].string {
            switch type {
                case "gif":
                    msg.type = .GIF
                    msg.src = json["src"].string
                case "image":
                    msg.type = .Image
                    msg.src = json["src"].string
                default:
                    msg.type = .Text
                    msg.text = json["text"].string
                    break
            }
        }
        
        return msg
    }
    
}