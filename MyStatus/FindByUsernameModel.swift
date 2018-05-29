//
//  FindByUsernameModel.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse

class FindByUsernameModel{
    
    var usersname:String = ""
    
    
    func createRequest(toUser: String, completion: @escaping (Bool)->()) {
        
        
        if toUser == PFUser.current()?.username{
            UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "You cannot friend yourself"), animated: true, completion: nil)
            completion(true)
            return
        }
        
        print("User did not try to friend self.")
        
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: toUser)
                
        query.findObjectsInBackground { (object, error) in
            if error != nil {
                
                var displayErrorMessage = "Please try again later."
                if let errorMessage = (error! as NSError).userInfo["error"] {
                    
                    displayErrorMessage = errorMessage as! String
                }
                
                UIApplication.shared.endIgnoringInteractionEvents()
                UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: displayErrorMessage), animated: true, completion: nil)
                
                
            }else {
                if (object?.isEmpty)! {
                    
                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "User could not be found."), animated: true, completion: nil)
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                else if let userInfo = object {
                    
                    for object in userInfo{
                        
                        if let item = object as? PFObject {
                            self.usersname = item["username"] as! String
                            
                            let friendObject = item
                            
                            let user = PFUser.current()
                            
                            let checkQuery:PFQuery = PFUser.query()!
                            checkQuery.whereKey("objectId", equalTo: user?.objectId!)
                            checkQuery.findObjectsInBackground(block: { (object, error) in
                                if error != nil {
                                    
                                    var displayErrorMessage = "Please try again later."
                                    if let errorMessage = (error! as NSError).userInfo["error"] {
                                        
                                        displayErrorMessage = errorMessage as! String
                                    }
                                    
                                    UIApplication.shared.endIgnoringInteractionEvents()
                                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: displayErrorMessage), animated: true, completion: nil)
                                    
                                }else {
                                    
                                    if let userInfo = object {
                                        
                                        for object in userInfo{
                                            
                                            if let item = object as? PFObject {
                                                if item["Friends"] != nil {
                                                    let friends = item["Friends"] as! [String]
                                                    
                                                    if friends.contains(self.usersname) {
                                                        print("Already Has Friend")
                                                        UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "You are already friends with: \(self.usersname)"), animated: true, completion: nil)
                                                        
                                                        completion(true)
                                                        return
                                                    }else {
                                                        
                                                        
                                                        
                                                        let friendRequest = PFObject(className: "FriendRequest")
                                                        
                                                        friendRequest.setValue(PFUser.current(), forKey: "fromUser")
                                                        friendRequest.setValue(friendObject, forKey:"toUser" )
                                                        friendRequest.setValue("Pending", forKey: "Status")
                                                        
                                                        let acl = PFACL()
                                                        
                                                        acl.setWriteAccess(true, forUserId: (PFUser.current()?.objectId!)!)
                                                        acl.setReadAccess(true, forUserId: (PFUser.current()?.objectId!)!)
                                                        
                                                        acl.setWriteAccess(true, forUserId: friendObject.objectId!)
                                                        acl.setReadAccess(true, forUserId: friendObject.objectId!)
                                                        //acl.getPublicReadAccess = true
                                                        
                                                        
                                                        
                                                        friendRequest.acl = acl
                                                        
                                                        let cQuery = PFQuery(className: "FriendRequest")
                                                        cQuery.whereKey("fromUser", equalTo: PFUser.current()!)
                                                        cQuery.whereKey("toUser", equalTo: friendObject)
                                                        cQuery.whereKey("Status", equalTo: "Pending")
                                                        
                                                        cQuery.findObjectsInBackground(block: { (object, error) in
                                                            if error != nil{
                                                                
                                                                
                                                            }else {
                                                                
                                                                if (object?.isEmpty)!{
                                                                    print("cQuery object is empty")
                                                                    
                                                                    let c2Query = PFQuery(className: "FriendRequest")
                                                                    c2Query.whereKey("toUser", equalTo: PFUser.current()!)
                                                                    c2Query.whereKey("fromUser", equalTo: friendObject)
                                                                    c2Query.whereKey("Status", equalTo: "Pending")
                                                                    
                                                                    c2Query.findObjectsInBackground(block: { (object, error) in
                                                                        if (object?.isEmpty)!{
                                                                            friendRequest.saveInBackground(block: { (success, error) in
                                                                                if error != nil {
                                                                                    print("Error")
                                                                                }else{
                                                                                    print("FREQ sent successfully")
                                                                                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "User Added", message: "You successfully sent a friend request to: \(self.usersname)"), animated: true, completion: nil)
                                                                                    
                                                                                    completion(true)
                                                                                    
                                                                                    
                                                                                }
                                                                            })
                                                                            
                                                                            //user?.add(self.usersname, forKey: "Friends")
                                                                            
                                                                            //user?.saveInBackground()
                                                                            
                                                                            
                                                                        }else{
                                                                            
                                                                            
                                                                            UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "\(self.usersname) has already sent you a friend request."), animated: true, completion: nil)
                                                                        }
                                                                    })
                                                                    
                                                                    
                                                                    
                                                                    
                                                                }else{
                                                                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "You already sent a friend request to: \(self.usersname)"), animated: true, completion: nil)
                                                                    
                                                                }
                                                            }
                                                        })
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                }else {
                                                    
                                                    print("First request being sent")
                                                    
                                                    let friendRequest = PFObject(className: "FriendRequest")
                                                    
                                                    friendRequest.setValue(PFUser.current(), forKey: "fromUser")
                                                    friendRequest.setValue(friendObject, forKey:"toUser" )
                                                    friendRequest.setValue("Pending", forKey: "Status")
                                                    
                                                    let acl = PFACL()
                                                    
                                                    
                                                    acl.setWriteAccess(true, forUserId: (PFUser.current()?.objectId!)!)
                                                    acl.setReadAccess(true, forUserId: (PFUser.current()?.objectId!)!)
                                                    
                                                    acl.setWriteAccess(true, forUserId: friendObject.objectId!)
                                                    acl.setReadAccess(true, forUserId: friendObject.objectId!)

                                                    
                                                    friendRequest.acl = acl
                                                    
                                                    friendRequest.saveInBackground()
                                                    
                                                    //user?.add(self.usersname, forKey: "Friends")
                                                    
                                                    //user?.saveInBackground()
                                                    
                                                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "User Added", message: "You successfully sent a friend request to: \(self.usersname)"), animated: true, completion: nil)
                                                    
                                                    completion(true)
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                    
                                }
                            })
                            
                            
                            
                        }
                        
                    }
                    
                }
                
                
                
            }
        }

        
    }
    
    
    func addFriendByUserName(username:String, completion: @escaping (Bool)->()){
        
        if username == PFUser.current()?.username{
            UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "You cannot friend yourself"), animated: true, completion: nil)
            completion(true)
            return
        }
        
        print("User did not try to friend self.")
        
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: username)
        
        query.findObjectsInBackground { (friendDataObject, error) in
            if error != nil {
                
                var displayErrorMessage = "Please try again later."
                if let errorMessage = (error! as NSError).userInfo["error"] {
                    
                    displayErrorMessage = errorMessage as! String
                }
                
                UIApplication.shared.endIgnoringInteractionEvents()
                UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: displayErrorMessage), animated: true, completion: nil)
                
                
            }else {
                if (friendDataObject?.isEmpty)! {
                    
                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "User could not be found."), animated: true, completion: nil)
                    
                    completion(true)
                }
                else if let userInfo = friendDataObject {
                  
                    for object in userInfo{
                        
                        if let item = object as? PFObject {
                            self.usersname = item["username"] as! String
                            let friendData = friendDataObject as! PFObject
                            
                            let user = PFUser.current()
                            
                            let checkQuery:PFQuery = PFUser.query()!
                            checkQuery.whereKey("objectId", equalTo: user?.objectId!)
                            checkQuery.findObjectsInBackground(block: { (object, error) in
                                if error != nil {
                                    
                                    var displayErrorMessage = "Please try again later."
                                    if let errorMessage = (error! as NSError).userInfo["error"] {
                                        
                                        displayErrorMessage = errorMessage as! String
                                    }
                                    
                                    UIApplication.shared.endIgnoringInteractionEvents()
                                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: displayErrorMessage), animated: true, completion: nil)
                                    
                                }else {
                                    
                                    if let userInfo = object {
                                        
                                        for object in userInfo{
                                            
                                            if let item = object as? PFObject {
                                                if item["Friends"] != nil {
                                                    let friends = item["Friends"] as! [String]
                                                    
                                                    if friends.contains(self.usersname) {
                                                        print("Already Has Friend")
                                                        UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "You are already friends with: \(self.usersname)"), animated: true, completion: nil)
                                                        
                                                        completion(true)
                                                        return
                                                    }else {
                                                        
                                                        user?.add(self.usersname, forKey: "Friends")
                                                        
                                                        
                                                        user?.saveInBackground()
                                                        
                                                        UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "User Added", message: "You successfully added: \(self.usersname)"), animated: true, completion: nil)
                                                        
                                                        completion(true)
                                                        
                                                    }

                                                    
                                                }else {
                                                    
                                                    print("First friend being added")
                                                    user?.add(self.usersname, forKey: "Friends")
                                                    friendData.add(PFUser.current()?.username!, forKey: "Friends")
                                                    
                                                    friendData.saveInBackground()
                                                    
                                                    user?.saveInBackground()
                                                    
                                                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "User Added", message: "You successfully added: \(self.usersname)"), animated: true, completion: nil)
                                                    
                                                    completion(true)
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                    
                                }
                            })
                            
                            
                            
                        }
                        
                    }
                    
                }
                
                
                
            }
        }
    
    }
    
    func sendNotifyPush(userName: String){
        let currentUserFullName = PFUser.current()?.value(forKey: "FullName") as! String
        let currentUserName = PFUser.current()?.value(forKey: "username") as! String
        
        let message = "\(currentUserFullName) (\(currentUserName)) has sent you a friend request."
        PFCloud.callFunction(inBackground: "sendPushToUser", withParameters: ["friendName" : userName, "message": message], block: { (success, error) in
            if error != nil {
                
                print(error!)
            }else {
                print("Push successfully sent to: \(userName)")
                PFCloud.callFunction(inBackground: "changeFRQBadge", withParameters: ["username" : userName], block: { (success, error) in
                    if error != nil{
                        print(error!)
                    }else{
                        print("Friend badge incremented for: \(userName)")
                    }
                })
            }
        })

    }
    
    
}
