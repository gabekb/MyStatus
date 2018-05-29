//
//  FriendStatusVCModel.swift
//  MyStatus
//
//  Created by GKB on 5/24/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse

class FriendStatusVCModel{
    
    var userFriends = [String]()
    var friendStatus = [String]()
    var extraDetails = [String]()
    var userFriendsNames = [String]()
    var friendPhoto = [PFFile]()

    
    
    func queryForFriendInfo(completion: @escaping (Bool) -> ()){
        
        
        let query : PFQuery = PFUser.query()!
        
        let userObjectID = PFUser.current()?.objectId!
        
        query.whereKey("objectId", equalTo: userObjectID!)
        
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (object, error) in
            if error != nil {
                print("Error Occurred obtaining status")
            }else {
                
                self.userFriends.removeAll()
                self.friendStatus.removeAll()
                self.extraDetails.removeAll()
                self.userFriendsNames.removeAll()
                self.friendPhoto.removeAll()
                
                print(object!)
                
                if let userInfo = object {
                    
                    for itemObject in userInfo{
                        
                        if let item = itemObject as? PFObject {
                            
                            if item["Friends"] != nil {
                                
                                self.userFriends = item["Friends"] as! [String]
                                
                                
                                
                                //self.userFriends = self.userFriends.reversed()
                                
                                let statusQuery : PFQuery = PFUser.query()!
                                
                                statusQuery.whereKey("username", containedIn: self.userFriends)
                                
                                statusQuery.order(byDescending: "createdAt")
                                
                                
                                statusQuery.findObjectsInBackground(block: { (objects, error) in
                                    if error != nil{
                                        print("Error occurred")
                                        
                                    }else {
                                        
                                        if let friendInfo = objects {
                                            
                                            self.userFriends.removeAll()
                                            
                                            for friendObject in friendInfo{
                                                
                                                
                                                if let info = friendObject as? PFObject {
                                                    
                                                    
                                                    self.userFriends.append(info["FullName"] as! String)
                                                    self.friendStatus.append(info["Status"] as! String)
                                                    
                                                    self.extraDetails.append(info["ExtraDetails"] as! String)
                                                    
                                                    self.userFriendsNames.append(info["username"] as! String)
                                                    
                                                    if info["userImage"] != nil{
                                                        
                                                        self.friendPhoto.append(info["userImage"] as! PFFile)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        
                                        
                                        
                                        completion(true)
                                        
                                    }
                                })
                                
                                
                            }else {
                                
                                
                                print("user has no friends")
                                completion(true)
                            }
                            
                            
                        }
                        
                    }
                    
                    
                }
            }
        }
        
        
        
        
    }
    var newFriends = [String]()

    
    func checkForAcceptedFriendRequests(completion: @escaping (Bool) -> ()){
        //self.newFriends.removeAll()
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("Status", equalTo: "Accepted")
        query.whereKey("fromUser", equalTo: PFUser.current()!)
        
        query.findObjectsInBackground { (object, error) in
            if error != nil{
                print("Error occured")
                
            }else{
                if (object?.isEmpty)!{
                    
                    print("uviyviyv")
                    completion(true)
                }
                else if let x = object{
                    for item in x{
                        print("Item in X", item)
                        
                        if let obj = item as? PFObject{
                            print(obj, "THISISACCEPTED")
                            print(self.newFriends, "New Friends")
                            let t = obj["toUser"] as! PFObject
                            let friendObjId = t.objectId!
                            
                            let friendUserNameQuery : PFQuery = PFUser.query()!
                            
                            friendUserNameQuery.whereKey("objectId", equalTo: friendObjId)
                            
                            friendUserNameQuery.findObjectsInBackground(block: { (object, error) in
                                if error != nil{
                                    
                                    
                                }else{
                                    
                                    if let objec = object{
                                        for data in objec {
                                            
                                            if let z = data as? PFObject{
                                                print(self)
                                                
                                                self.newFriends.append(z["username"] as! String)
                                                
                                            }
                                        }
                                        completion(true)
                                    }
                                }
                            })
                            
                        }
                    }
                    //completion(true)
                }
                
                
            }
        }
        
        
        
        
        
        
    }
    
    var usersname:String = ""

    
    
    func addFriendByUserName(userName: String, completion: @escaping (Bool)->()){
        if userName == PFUser.current()?.username{
            UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "You cannot friend yourself"), animated: true, completion: nil)
            completion(true)
            return
        }
        
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: userName)
        
        query.findObjectsInBackground { (object, error) in
            if error != nil {
                
                var displayErrorMessage = "Please try again later."
                if let errorMessage = (error! as NSError).userInfo["error"] {
                    
                    displayErrorMessage = errorMessage as! String
                }
                
                UIApplication.shared.endIgnoringInteractionEvents()
                UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: displayErrorMessage), animated: true, completion: nil)
                
                completion(true)
            }else {
                if (object?.isEmpty)! {
                    
                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "User could not be found."), animated: true, completion: nil)
                    
                    completion(true)
                }
                else if let userInfo = object {
                    
                    for object in userInfo{
                        
                        if let item = object as? PFObject {
                            self.usersname = item["username"] as! String
                            
                            let user = PFUser.current()
                            
                            user?.fetchInBackground(block: { (object, error) in
                                if error != nil{
                                    var displayErrorMessage = "Please try again later."
                                    if let errorMessage = (error! as NSError).userInfo["error"] {
                                        
                                        displayErrorMessage = errorMessage as! String
                                    }
                                    
                                    UIApplication.shared.endIgnoringInteractionEvents()
                                    UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: displayErrorMessage), animated: true, completion: nil)
                                    completion(true)
                                }else{
                                    
                                    if PFUser.current()?.value(forKey: "Friends") != nil{
                                        
                                        let friends = PFUser.current()?.value(forKey: "Friends") as! [String]
                                        
                                        if friends.contains(self.usersname){
                                            print("Already Has Friend")
                                            UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "You are already friends with: \(self.usersname)"), animated: true, completion: nil)
                                            completion(true)
                                            
                                        }else{
                                            PFUser.current()?.add(self.usersname, forKey: "Friends")
                                            
                                            PFUser.current()?.saveInBackground()
                                            
                                            UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "User Added", message: "You successfully added: \(self.usersname)"), animated: true, completion: nil)
                                            completion(true)
                                        }
                                    }else{
                                        
                                        print("First friend being added")
                                        PFUser.current()?.add(self.usersname, forKey: "Friends")
                                        
                                        PFUser.current()?.saveInBackground()
                                        
                                        UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "User Added", message: "You successfully added: \(self.usersname)"), animated: true, completion: nil)
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

    
    func changeReqStatus(toUser: String, newStatus: String, completion: @escaping (Bool) -> ()){
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: toUser)
        
        query.findObjectsInBackground { (object, error) in
            if error != nil{
                print("An error occurred")
                
            }else{
                
                for obj in object!{
                    if let y = obj as? PFObject{
                        
                        print(y, "FROMUSER")
                        let reqQuery = PFQuery(className: "FriendRequest")
                        reqQuery.whereKey("fromUser", equalTo: PFUser.current()!)
                        reqQuery.whereKey("toUser", equalTo: y)
                        
                        reqQuery.findObjectsInBackground(block: { (object, error) in
                            if error != nil{
                                
                                print("An error occurred")
                            }else {
                                for item in object!{
                                    
                                    if let x = item as? PFObject{
                                        
                                        
                                        x["Status"] = "Accepted & Confirmed"
                                        
                                        
                                        x.saveInBackground(block: { (success, error) in
                                            if error != nil{
                                                print(error!)
                                            }else {
                                                completion(true)
                                            }
                                        })
                                        
                                        
                                        
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
