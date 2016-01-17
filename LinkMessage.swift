//
//  LinkMessage.swift
//  Peach
//
//  Created by Stephen Radford on 17/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

public class LinkMessage: Message {
    
    /// Title of the link
    public var title: String?
    
    /// Image URL associated to the link
    public var imageURL: String?
    
    /// URL to the link
    public var url: String?
    
    /// Description of the link
    public var description: String?
    
    // MARK: - Message Protocol
    
    public required init() { }
    
    public var type: MessageType = .Link
    
    public var dictionary: [String:String] {
        get {
            return [:]
        }
    }
    
    public static func messageFromJson(json: JSON) -> Message {
        let msg = LinkMessage()
        msg.title = json["title"].string
        msg.imageURL = json["imageURL"].string
        msg.url = json["url"].string
        msg.description = json["description"].string
        return msg
    }
    
}