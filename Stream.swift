//
//  Connection.swift
//  Peach
//
//  Created by Stephen Radford on 10/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public struct Stream {
    
    /// Unique ID of the stream
    public var id: String?
    
    /// Username belonging to the stream
    public var name: String?
    
    /// Display name belonging to the stream
    public var displayName: String?
    
    /// URL to the avatar
    public var avatarSrc: String?
    
    /// Is the profile public?
    public var isPublic: Bool = false
    
    /// Do you follow the profile?
    public var youFollow: Bool = false
    
    /// Do they follow you?
    public var followsYou: Bool = false
    
    /// Array of `Post`s
    private var _posts: [Post] = []
    
    /// Posts sorted in reverse crono order
    public var posts: [Post] {
        get {
            return _posts.sort { $0.createdTime > $1.createdTime }
        }
    }
    
    /**
     Fetch the avatar using the src URL
     
     - parameter callback: Returns a NSImage if successful
     */
    public func getAvatar(callback: (NSImage) -> Void) {
        
        if let src = avatarSrc {
            Alamofire.request(.GET, src)
                .responseData { response in
                    if response.result.isSuccess {
                        if let img = NSImage(data: response.result.value!) {
                            callback(img)
                        }
                    }
                }
        }
        
    }
    
}

extension Peach {
    
    typealias Connection = Stream
    
    /**
     Fetch streams from the Peach API
     
     - parameter callback: Callback returns array of streams and optional `NSError`
     */
    public class func getStreams(callback: ([Stream], NSError?) -> Void) {
        
        Alamofire.request(API.Connections)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let data = json["data"].dictionary {
                            if let connections = data["connections"]?.array {
                                let streams = connections.map(parseStream)
                                callback(streams, response.result.error)
                                return
                            }
                        }
                    }
                }
                
                callback([], response.result.error)
            }
        
    }
    
    /**
     Parse the raw JSON into a beautiful peachy stream
     
     - parameter json: Raw SwifyJSON
     
     - returns: Parsed `Stream`
     */
    internal class func parseStream(json: JSON) -> Stream {
        var stream = Stream()
        stream.id = json["id"].string
        stream.name = json["name"].string
        stream.displayName = json["displayName"].string
        stream.avatarSrc = json["avatarSrc"].string
        
        if let isPublic = json["isPublic"].bool {
            stream.isPublic = isPublic
        }
        
        if let youFollow = json["youFollow"].bool {
            stream.youFollow = youFollow
        }
        
        if let followsYou = json["followsYou"].bool {
            stream.followsYou = followsYou
        }
        
        if let posts = json["posts"].array {
            stream._posts = posts.map(parsePost)
        }
        
        return stream
    }
    
    /**
     Fetch connections from the Peach API. This is an alias of streams.
     
     - parameter callback: Callback returns array of streams and optional `NSError`
     */
    public class func getConnections(callback: ([Stream], NSError?) -> Void) {
        self.getStreams(callback)
    }
    
    /**
     Fetch a stream by its ID
     
     - parameter id:       The stream ID
     - parameter callback: Callback returns stream and optional NSError
     */
    public class func getStreamByID(id: String, callback: (Stream?, NSError?) -> Void) {
        
        Alamofire.request(API.Stream(id))
            .responseJSON { response in
                
                if response.result.isSuccess {
                    Swift.print(response.result.value)
                } else {
                    callback(nil, response.result.error)
                }
                
            }
        
    }
    
}