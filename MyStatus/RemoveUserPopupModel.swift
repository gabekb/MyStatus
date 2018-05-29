//
//  RemoveUserPopupModel.swift
//  MyStatus
//
//  Created by GKB on 4/30/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse

class RemoveUserPopupModel{
    
    func removeFriend(username: String, completion: @escaping (Bool) -> ()){
        
        var friends = PFUser.current()?.value(forKey: "Friends") as! [String]
        
        print(friends)
        friends = friends.filter{$0 != username}
        print(friends)
        
        let user = PFUser.current()
        user?.setValue(friends, forKey: "Friends")
        user?.saveInBackground()
        
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: username)
        
        query.findObjectsInBackground { (object, error) in
            if error != nil{
                print("An error occurred")
            }else{
                for obj in object!{
                    if let x = obj as? PFObject{
                        let friendObjId = x.objectId!
                        
                        
                        let currentUser = PFUser.current()?.username
                        PFCloud.callFunction(inBackground: "removeFriend", withParameters: ["userObjId": friendObjId, "currentUser": currentUser!], block: { (success, error) in
                            if error != nil{
                                print(error!, "ASDASDASDASDJLASDLASDKNASD")
                            }else{
                                //print("Successfully removed user")
                            }
                        })
                    }
                }
                
            }
        }
        
        completion(true)
    }
    
    
    func deleteFriendRequest(username: String){
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
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
        
        
        
        
    }
    
}
