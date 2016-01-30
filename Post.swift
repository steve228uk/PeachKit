//
//  Post.swift
//  Peach
//
//  Created by Stephen Radford on 10/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class Post {
    
    /// Unique ID of the post
    public var id: String?
    
    /// Array of messages relating to the post
    public var message: [Message] = []
    
    /// How many comments are on the post
    public var commentCount: Int?
    
    /// How many likes are on the post
    public var likeCount: Int?
    
    /// Array of comments
    public var comments: [Comment] = []
    
    /// Was this post liked by the logged in user
    public var likedByMe: Bool = false
    
    /// Is the post unread
    public var isUnread: Bool = false
    
    /// When was this post created
    public var createdTime: Int64?
    
    /// When was this post updated
    public var updatedTime: Int64?
    
    /**
     Like the post on Peach
     
     - parameter callback: Optional callback
     */
    public func like(callback: ((NSError?) -> Void)?) {
        if let postID = id {
            if !likedByMe {
                Alamofire.request(API.LikePost(postID))
                    .responseJSON { response in
                        self.likedByMe = true
                        if let count = self.likeCount {
                            self.likeCount = count + 1
                        }
                        callback?(response.result.error)
                    }
            } else {
                Alamofire.request(API.UnlikePost(postID))
                    .responseJSON { response in
                        self.likedByMe = false
                        if let count = self.likeCount {
                            self.likeCount = count - 1
                        }
                        callback?(response.result.error)
                    }
            }
        }
    }
    
    /**
     Like the post on Peach
     */
    public func like() {
        like(nil)
    }
    
}

extension Peach {
    
    /**
     Map a post from raw JSON to the Peach Post
     
     - parameter json: SwiftyJSON
     
     - returns: A Peach Post
     */
    internal class func parsePost(json: JSON) -> Post {
        let post = Post()
        
        post.id = json["id"].string
        post.commentCount = json["commentCount"].int
        post.updatedTime = json["updatedTime"].int64
        post.createdTime = json["createdTime"].int64
        post.likeCount = json["likeCount"].int
        
        if let liked = json["likedByMe"].bool {
            post.likedByMe = liked
        }
        
        if let isUnread = json["isUnread"].bool {
            post.isUnread = isUnread
        }
        
        if let msg = json["message"].array {
            post.message = msg.map(parseMessage)
        }
        
        if let comments = json["comments"].array {
            post.comments = comments.map(parseComments)
        }
        
        return post
    }
    
    /**
     Create a new post on peach
     
     - parameter messages: An array of messages to send to peach
     - parameter callback: Catch any errors that may occur
     */
    public class func createPost(messages: [Message], callback: (NSError?) -> Void) {
        
        let msgs = ["message": messages.map { $0.dictionary }]
        
        Alamofire.request(API.CreatePost(msgs))
            .responseJSON { response in
                callback(response.result.error)
            }
        
    }
    
}
