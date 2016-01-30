//
//  Comment.swift
//  Peach
//
//  Created by Stephen Radford on 10/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import SwiftyJSON

public struct Comment {
    
    /// The ID of the comment
    public var id: String?
    
    /// The author of the comment. Stream.
    public var author: Stream?
    
    /// The text of the comment
    public var body: String?
    
}

extension Peach {
    
    class func parseComments(json: JSON) -> Comment {
        var comment = Comment()
        
        if let id = json["id"].string {
            comment.id = id
        }
        
        if let body = json["body"].string {
            comment.body = body
        }
        
        comment.author = parseStream(json["author"])
        
        return comment
    }
    
}