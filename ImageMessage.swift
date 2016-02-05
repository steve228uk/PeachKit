//
//  ImageMessage.swift
//  Peach
//
//  Created by Stephen Radford on 17/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class ImageMessage: Message {
    
    public required init() { }
    
    /// Source URL of any image
    public var src: String?
    
    /// Width of any image
    public var width: Int?
    
    /// Height of any image
    public var height: Int?
    
    /**
     Fetch the image related to the message
     
     - parameter callback: Callback with NSImage
     */
    public func getImage(callback: (NSImage) -> Void) {
        if let url = src {
            Alamofire.request(.GET, url)
                .responseData { response in
                    if response.result.isSuccess {
                        if let img = NSImage(data: response.result.value!) {
                            callback(img)
                        }
                    }
            }
            
        }
    }
    
    /**
     Fetch the image data related to the message
     
     - parameter callback: Callback with NSImage
     */
    public func getImageData(callback: (NSData) -> Void) {
        if let url = src {
            Alamofire.request(.GET, url)
                .responseData { response in
                    if response.result.isSuccess {
                        callback(response.result.value!)
                    }
            }
            
        }
    }
    
    // MARK: - Message Protocol
    
    public var type: MessageType = .Image
    
    public static func messageFromJson(json: JSON) -> Message {
        let msg = ImageMessage()
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
        return msg
    }
    
    public var dictionary: [String:AnyObject] {
        get {
            return [
                "type": type.stringValue.lowercaseString,
                "width": (width != nil) ? width! : 0,
                "height": (height != nil) ? height! : 0,
                "src": (src != nil) ? src! : ""
            ]
        }
    }
    
}