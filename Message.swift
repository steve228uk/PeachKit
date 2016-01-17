//
//  Message.swift
//  Peach
//
//  Created by Stephen Radford on 10/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public protocol Message {
    
    /// What type of message is this?
    var type: MessageType { get set }
    
    /**
     Parse json and return an instance of the message
     */
    static func messageFromJson(json: JSON) -> Message
    
    /// This is the dictionary that is used
    var dictionary: [String:String] { get }
    
    init()
    
}


public enum MessageType {
    
    case Text
    case GIF
    case Image
    case Shout
    case Video
    case Drawing
    case Location
    case Music
    case Link
    
    public var stringValue: String {
        switch self {
        case .Text:
            return "Text"
        case .GIF:
            return "GIF"
        case .Image:
            return "Image"
        case .Shout:
            return "Shout"
        case .Video:
            return "Video"
        case .Drawing:
            return "Drawing"
        case .Location:
            return "Location"
        case .Music:
            return "Music"
        case .Link:
            return "Link"
        }
    }
    
}

extension Peach {
    
    /**
     Parse messages from a post
     
     - parameter json: The raw JSON
     
     - returns: The parsed message
     */
    internal class func parseMessage(json: JSON) -> Message {
        
        switch json["type"].string! {
        case "gif":
            var msg = ImageMessage.messageFromJson(json)
            msg.type = .GIF
            return msg
            
        case "image":
            if let subtype = json["subtype"].string {
                Swift.print(subtype)
            }
            return ImageMessage.messageFromJson(json)
            
        default:
            return TextMessage.messageFromJson(json)
        }
    
    }
    
}