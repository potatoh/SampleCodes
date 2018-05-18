//
//  Bottle.swift
//  Crush
//
//  Created by Sherif Ahmed on 4/16/18.
//  Copyright © 2018 DREIDEV. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Status: Int {
    case ACCEPTED = 0
    case REJECTED = 1
    case NEW = 2
    case COLLECTED = 3
}

class Bottle {
    
    var id: Int
    var latitude: Double
    var longitude: Double
    var receiver: String
    var status: Int
    
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.receiver = json["receiver"].stringValue
        self.status = json["status"].intValue
    }
    
    
}
