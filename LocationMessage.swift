//
//  LocationMessage.swift
//  Peach
//
//  Created by Stephen Radford on 17/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

public class LocationMessage: Message {
    
    /// The name of the location
    public var name: String?
    
    /// The longtitude of the location
    public var long: Float?
    
    /// The latitude of the location
    public var lat: Float?
    
    /// The Foursquare ID of the location
    public var foursquareID: String?
    
    /// URL to the icon
    public var iconSrc: String?
    
    /// Address lines
    public var formattedAddress: [String] = []
    
    // MARK: - Message Protocol
    
    public required init() { }
    
    public var type: MessageType = .Location
    
    public var dictionary: [String:AnyObject] {
        get {
            return [:]
        }
    }
    
    public static func messageFromJson(json: JSON) -> Message {
        let msg = LocationMessage()
        msg.name = json["name"].string
        msg.long = json["long"].float
        msg.lat = json["lat"].float
        msg.foursquareID = json["f®oursquareId"].string
        msg.iconSrc = json["iconSrc"].string
        
        if let address = json["formattedAddress"].array {
            msg.formattedAddress = address.map { $0.string! }
        }
        
        return msg
    }

    
}