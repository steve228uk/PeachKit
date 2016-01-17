//
//  VideoMessage.swift
//  Peach
//
//  Created by Stephen Radford on 17/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VideoMessage: Message {
    
    public required init() { }
    
    /// Width of the video
    public var width: Int?
    
    ///  height of the video
    public var height: Int?
    
    /// Link to the video in MP4
    public var src: String?
    
    /// Link to the image that can be used as a poster when loading
    public var posterSrc: String?
    
    // MARK: - Message Protocol
    
    public var type: MessageType = .Video
    
    public static func messageFromJson(json: JSON) -> Message {
        let msg = VideoMessage()
        
        if let stringWidth = json["width"].string {
            msg.width = Int(stringWidth)
        } else {
            msg.width = json["width"].int
        }
        if let stringHeight = json["height"].string {
            msg.height = Int(stringHeight)
        } else {
            msg.height = json["height"].int
        }

        msg.src = json["src"].string
        msg.posterSrc = json["posterSrc"].string
        
        return msg
    }
    
    public var dictionary: [String:String] {
        get {
            return [:]
        }
    }
    
}