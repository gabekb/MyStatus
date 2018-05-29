//
//  FriendStatusPageVCModel.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse

class FriendStatusPageVCModel{
    
    
    func deleteFriendRequest(username: String, completion: @escaping (Bool) -> ()){
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: username)
        query.findObjectsInBackground { (object, error) in
            if error != nil{
                print("An error occurred")
                
            }else{
                
                if let fObj = object{
                    for item in fObj{
                        
                        if let userObj = item as? PFObject{
                            
                            let delQuery = PFQuery(className: "FriendRequest")
                            delQuery.whereKey("fromUser", equalTo: userObj)
                            delQuery.whereKey("toUser", equalTo: PFUser.current()!)
                            
                            delQuery.findObjectsInBackground(block: { (object, error) in
                                if error != nil{
                                    print("An error occurred")
                                    
                                }else{
                                    
                                    for data in object! {
                                        data.deleteInBackground()
                                        completion(true)
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
        
        
        
        
    }
    
    func signOut(completion: @escaping (Bool) -> ()) {
        
        PFUser.logOutInBackground { (error) in
            if error != nil {
                print("An error occurred.")
            }else {
                
                print("Signed out successfully")
                completion(true)
            }
        }
        
    }
    
    
}
