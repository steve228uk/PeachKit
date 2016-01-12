//
//  User.swift
//  Peach
//
//  Created by Stephen Radford on 10/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class User {
    
    /**
     Authenticate with the Peach API. A token will be returned from the API on successful authentication which should be stored for authentication at a later date.
     
     - parameter credentials: Tuple containing email and password
     - parameter callback:    Callback to determine wheteher the authentication was successful or not
     */
    public class func authenticateWithCredentials(credentials: (email: String, password: String), callback: ((token: String, streamID: String)?, NSError?) -> Void) {
        
        Alamofire.request(API.Authenticate(credentials.email, credentials.password))
            .responseJSON { response in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let data = json["data"].dictionary {
                            let streams = data["streams"]!.array!
                            let stream = streams[0].dictionary!
                            
                            callback((token: stream["token"]!.string!, streamID: stream["id"]!.string!), response.result.error)
                        }
                        callback(nil, response.result.error)
                    } else {
                        callback(nil, response.result.error)
                    }
                } else {
                    callback(nil, response.result.error)
                }
            }
        
    }
    
}