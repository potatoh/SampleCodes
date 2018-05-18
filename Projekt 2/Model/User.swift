//
//
//  Clinic System
//
//  Created by Sherif Ahmed on 5/10/17.
//  Copyright © 2017 Sherif Ahmed. All rights reserved.
//

import Foundation
/**
 User Model .
 ````
 public var id : Int?
 public var name : String?
 public var image : String?
 ````
 
 - id: ID of the Object.
 - name: Name of the object.
 - image: Image Path (url) for the image of the object.
 
 ## Important Notes ##
 - This Class inherits from **BaseModel Class**
 */
class User : BaseModel {

    public var email : String?
    public var mobile : String?
    public var gender : Gender?
    public var languages : String?
    public var birthday : String?
    public var address : String?
    public var is_active : Bool?
    public var role : Role?
    public var bio : String?
    public var speciality : String?
    public var unique_id : String?

    override init(data:AnyObject){
        super.init(data: data)
        if let data = data as? NSDictionary {
            email = data.getValueForKey(key: "email", callback: "")
            mobile = data.getValueForKey(key: "mobile", callback: "")
            gender = Gender(rawValue: data.getValueForKey(key: "gender", callback: 0))
            role = Role(rawValue: data.getValueForKey(key: "role_id", callback: 3))
            languages = data.getValueForKey(key: "languages", callback: "")
            is_active = data.getValueForKey(key: "is_active", callback: 0) == 1
            birthday = data.getValueForKey(key: "birthday", callback: "")
            address = data.getValueForKey(key: "address", callback: "")
            unique_id = data.getValueForKey(key: "unique_id", callback: "")
            bio = data.getValueForKey(key: "bio", callback: "")
            speciality = data.getValueForKey(key: "speciality", callback: "Assistant")
        }
    }
    
    override init() {
        super.init()
    }
}
