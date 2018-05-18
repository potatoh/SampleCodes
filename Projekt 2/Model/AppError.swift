import Foundation

/**
 For identifying the error returned from the API response.
 ````
 public var type : String?
 public var desc : String?
 public var code : AppErrorCode?
 ````
 
 - type: string returned to declare the request state (fail,success).
 - desc: string returned with the description of the response.
 - code: the type of the error code returned in a class **AppErrorCode**.
 
 ## Important Notes ##
 - Access Token got from this class.
 */
class AppError {
    public var type : String?
    public var desc : String?
    public var code : AppErrorCode?
    
    init(data:AnyObject){
        if let data = data as? NSDictionary {
            type = data.getValueForKey(key: "type", callback: "")
            desc = data.getValueForKey(key: "desc", callback: "")
            code = AppErrorCode(rawValue: data.getValueForKey(key: "code", callback: 5))
            let token = data.getValueForKey(key: "token", callback: "")
            if token != "" {
                ACCESS_TOKEN = token
                userData.set(ACCESS_TOKEN, forKey: "token")
            }
        }
    }

    
}
