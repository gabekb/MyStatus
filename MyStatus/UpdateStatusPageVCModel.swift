//
//  UpdateStatusPageVCModel.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse

class UpdateStatusPageVCModel{
    
    
    func updateStatus(status: String, extraDetails: String, image: UIImage, completion: @escaping (Bool)->()) {
        let user = PFUser.current()
        user?.setValue(status, forKey: "Status")
        user?.setValue(extraDetails, forKey: "ExtraDetails")
        
        
        if image != UIImage(named: "empty-profile"){
            let imageData = UIImageJPEGRepresentation(image, 0.6)
            
            let imageFile = PFFile(name: "image.png", data: imageData!)
            user?.setValue(imageFile, forKey: "userImage")
            
        }
        
        
        
        
        user?.saveInBackground(block: { (success, error) in
            if error != nil {
                
                print("An error occurred")
                UIApplication.shared.endIgnoringInteractionEvents()

                
            }else {
                print("Successfully updated status")
                UIApplication.shared.endIgnoringInteractionEvents()

                completion(true)
                
            }
        })
        
        }
    var userFriends = [String]()
    func notifyFriends(status: String) {
        
        let name = PFUser.current()?.value(forKey: "FullName") as? String
        
        let message = "\(name!) has updated their status to: \(status)"
        let query : PFQuery = PFUser.query()!
        
        query.whereKey("objectId", equalTo: PFUser.current()?.objectId!)
        query.findObjectsInBackground { (object, error) in
            if error != nil {
                print("Error Occurred obtaining status")
                UIApplication.shared.endIgnoringInteractionEvents()

                
            }else {
                
                self.userFriends.removeAll()
                
                print(object!)
                
                if let userInfo = object {
                    
                    for itemObject in userInfo{
                        
                        if let item = itemObject as? PFObject {
                            
                            if item["Friends"] != nil {
                                
                                //self.userFriends = object!
                               
                                self.userFriends = item["Friends"] as! [String]
                                
                                
                                for friend in self.userFriends{
                                    
                                    PFCloud.callFunction(inBackground: "sendPushToUser", withParameters: ["friendName" : friend, "message": message], block: { (success, error) in
                                        if error != nil {
                                            
                                            print(error!)
                                        }else {
                                            print("Push successfully sent to: \(friend)")
                                            
                                            PFCloud.callFunction(inBackground: "changeFriendBadge", withParameters: ["username" : friend], block: { (success, error) in
                                                if error != nil{
                                                    print(error!)
                                                }else{
                                                    print("Friend badge incremented for: \(friend)")
                                                }
                                            })
                                        }
                                    })
                                    
                                    
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        
    }
    
}
