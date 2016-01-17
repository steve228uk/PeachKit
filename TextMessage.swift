//
//  TextMessage.swift
//  Peach
//
//  Created by Stephen Radford on 17/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TextMessage: Message {
    
    public required init() { }
    
    public var type: MessageType = .Text
    
    public static func messageFromJson(json: JSON) -> Message {
        let msg = TextMessage()
        msg.text = json["text"].string
        return msg
    }
    
    public var text: String?
    
    public var dictionary: [String:String] {
        get {
            return [
                "type": "text",
                "text": (text != nil) ? text! : ""
            ]
        }
    }

}