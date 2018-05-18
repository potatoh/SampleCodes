//
//  RequestManager.swift
//  ClinicSystem
//
//  Created by Sherif Ahmed on 2/21/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import Alamofire

/**
 **Manager of all API Reqesuts**.
 ````
 static let defaultManager = RequestManager()
 private let requestTimourInterval = 20.0
 ````
 
 - defaultManager: Default manager to confirm singleton pattern.
 - requestTimourInterval: Maximum time taken for the request.
 
 ## Important Notes ##
 - This Class Confirms **Singleton Design Pattern**
 
 */
class RequestManager{
    static let defaultManager = RequestManager()
    private init (){}


     /**
     Requesting a signup process to the API.
     Returns Closure With Parameters :
     - Parameter error: Boolean if the request has been done successfully.
     - Parameter results: Array of the returned objects.
     - Parameter resError: Object of type **AppError** to return the error type which returned from API.
     
     ## Important Notes ##
     Parameters sent to the service API :
     - The Service sending the language (en/ar) in a **POST** method.
     - Parameter ID: The ID of the menu Category.
     - Parameter ACCOUNT_ID:  Current account ID.
     - Parameter name: User's name.
     - Parameter email: User's email.
     - Parameter password: User's password.
     - Parameter gender: User's gender.
     - Parameter mobile: User's mobile.
     - Parameter facebook_id: User's facebook ID.
     
     
     */
    func signUpWithemail(email:String,password:String,name:String,gender:Int,birthday:String, mobile:String,facebook_id:String? = "",compilition : @escaping (_ error : Bool,_ user:User?,_ resError:AppError?)->Void){
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "user/sign-up")!,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: requestTimourInterval)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        
        let postmsg = "email=\(email)&password=\(password)&name=\(name)&gender=\(gender)&birthday=\(birthday)&account_id=\(ACCOUNT_ID)&mobile=\(mobile)&facebook_id=\(facebook_id!)&is_facebook=\(facebook_id! == "" ? "" : "1")"
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                print(res.statusCode)
                if (error != nil || res.statusCode != 200) {
                    compilition(true,nil,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(json)
                    } catch {
                        compilition(true,nil,nil)
                    }
                    
                    var error:AppError!
                    var user:User!
                    
                    if let response = json["Error"] as? NSDictionary {
                        error = AppError(data: response)
                        if let res = json["Response"] as? NSDictionary {
                            user = User(data: res as AnyObject)
                        }
                        compilition(false,user!,error!)
                        return
                    }
                    
                    
                }
            }else {
                compilition(true,nil,nil)
            }
            
        })
        dataTask.resume()
    }

}