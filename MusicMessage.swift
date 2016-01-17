//
//  MusicMessage.swift
//  Peach
//
//  Created by Stephen Radford on 17/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

public class MusicMessage: Message {

    public var title: String?
    
    // MARK: - Message Protocol
    
    public required init() { }
    
    public var type: MessageType = .Music
    
    public var dictionary: [String:String] {
        get {
            return [:]
        }
    }
    
    public static func messageFromJson(json: JSON) -> Message {
        let msg = MusicMessage()
        // TODO: Pull out iTunes and Spotify data returned by the Peach API
        msg.title = json["title"].string
        return msg
    }

}