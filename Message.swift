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
    var dictionary: [String:AnyObject] { get }
    
    init()
    
}


public enum MessageType {
    
    case Text
    case GIF
    case Image
    case Shout
    case Video
    case LoopingPhoto
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
        case .LoopingPhoto:
            return "Looping Photo"
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
        case "text":
            return TextMessage.messageFromJson(json)
            
        case "gif":
            var msg = ImageMessage.messageFromJson(json)
            msg.type = .GIF
            return msg
            
        case "image":
            var msg = ImageMessage.messageFromJson(json)
            if let subtype = json["subtype"].string {
                switch subtype {
                case "drawing":
                    msg.type = .Drawing
                case "shout":
                    msg.type = .Shout
                default:
                    msg.type = .Image
                }
            }
            return msg
        
        case "video":
            var msg = VideoMessage.messageFromJson(json)
            if let subtype = json["subtype"].string {
                switch subtype {
                default:
                    msg.type = .LoopingPhoto
                }
            }
            return msg
            
        case "music":
            return MusicMessage.messageFromJson(json)
            
        case "location":
            return LocationMessage.messageFromJson(json)
            
        case "link":
            return LinkMessage.messageFromJson(json)
            
        default:
            return TextMessage.messageFromJson(json)
        }
    
    }
    
}