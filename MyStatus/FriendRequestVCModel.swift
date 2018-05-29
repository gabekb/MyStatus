//
//  FriendRequestVCModel.swift
//  MyStatus
//
//  Created by GKB on 4/27/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse

class FriendRequestVCModel {
    
    var usernameArray = [String]()
    var fullnameArray = [String]()
    var statusArray = [String]()
    var imageFileArray = [PFFile]()
    
    var usersname:String = ""
    
    
    func addFriendByUserName(userName: String, completion: @escaping (Bool)->()){
        if userName == PFUser.current()?.username{
            UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "You cannot friend yourself"), animated: true, completion: nil)
            completion(true)
            return
        }
        
        let query : PFQuery = PFUser.query()!
        //query.whereKey(userName, equalTo: "username")
        
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
    

    
    
    func changeReqStatus(fromUser: String, newStatus: String, completion: @escaping (Bool) -> ()){
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: fromUser)
        
        query.findObjectsInBackground { (object, error) in
            if error != nil{
                print("An error occurred")
                
            }else{
                
                for obj in object!{
                    if let y = obj as? PFObject{
                       
                        print(y, "FROMUSER")
                        let reqQuery = PFQuery(className: "FriendRequest")
                        reqQuery.whereKey("fromUser", equalTo: y)
                        reqQuery.whereKey("toUser", equalTo: PFUser.current()!)
                        reqQuery.whereKey("Status", equalTo: "Pending")


                        reqQuery.findObjectsInBackground(block: { (object, error) in
                            if error != nil{
                                
                                print("An error occurred")
                            }else {
                                for item in object!{
                                    
                                    if let x = item as? PFObject{
                                        
                                        
                                        x["Status"] = "Accepted"
                                        
                                        
                                        x.saveInBackground(block: { (success, error) in
                                            if error != nil{
                                                print(error!)
                                            }
                                        })
                                        completion(true)

                                        
                                    }
                                    
                                }
                                
                                
                            }
                        })
                    }
                }
                
                
            }
        }
    }
    
    func getRecievedFriendReq(completion: @escaping (Bool) -> ()){
        
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("toUser", equalTo: PFUser.current()!)
        query.whereKey("Status", equalTo: "Pending")
        
        query.findObjectsInBackground { (object, error) in
            if error != nil {
                print("An error occured")
                completion(true)
                
            }else {
                
                print(object!, "UATSDASDLSDDAS")
                if let info = object {
                    self.usernameArray.removeAll()
                    self.fullnameArray.removeAll()
                    self.imageFileArray.removeAll()
                    
                    
                    for item in info{
                        
                        if let t = item as? PFObject{
                            
                            let from = t["fromUser"] as! PFUser
                            let status = t["Status"]
                            
                            self.statusArray.append(status as! String)
                            
                            let userNameQuery:PFQuery = PFUser.query()!
                            
                            userNameQuery.whereKey("objectId", equalTo: from.objectId!)
                            
                            userNameQuery.findObjectsInBackground(block: { (object, error) in
                                if error != nil{
                                    
                                    print("An error occurred")
                                    
                                }else {
                                    
                                    if let temp = object{
                                        
                                        
                                        for obj in temp{
                                            if let x = obj as? PFObject{
                                                
                                                let userName = x["username"]
                                                let fullName = x["FullName"]
                                                let userImageFile = x["userImage"]
                                                
                                                
                                                self.usernameArray.append(userName as! String)
                                                self.fullnameArray.append(fullName as! String)
                                                self.imageFileArray.append(userImageFile as! PFFile)
                                                completion(true)

                                            }
                                            
                                        }
                                        
                                    }
                                }
                            })
                            
                            
                        }

                    }
                    completion(true)
                    
                    
                }
                
            }
        }
        
        
    }
    
    var sentStatusArray = [String]()
    var sentFullNameArray = [String]()
    var sentUserNameArray = [String]()
    var sentUserImageArray = [PFFile]()
    
    func getSentFriendReq(completion: @escaping (Bool) -> ()){
        
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("fromUser", equalTo: PFUser.current()!)
        //query.whereKey("Status", equalTo: "Pending")
        query.whereKey("Status", containedIn: ["Pending", "Accepted", "Accepted & Confirmed"])
        
        query.findObjectsInBackground { (object, error) in
            if error != nil {
                print("An error occured")

                completion(true)
                
            }else {
                
                //print(object!, "UATSDASDLSDDAS")
                if let info = object {

                    self.sentUserNameArray.removeAll()
                    self.sentFullNameArray.removeAll()
                    self.sentUserImageArray.removeAll()
                    self.sentStatusArray.removeAll()
                    
                    
                    for item in info{
                        
                        print("T WAS SET!!!")

                        if let t = item as? PFObject{
                            
                            
                            let toUser = t["toUser"] as! PFUser
                            let status = t["Status"]
                            
                            
                            toUser.fetchInBackground(block: { (object, error) in
                                if error != nil{
                                    print("Fetch if needed failed")
                                    
                                }else{
                                    
                                    
                                    self.sentUserNameArray.append(object?.value(forKey: "username") as! String)
                                    
                                    self.sentFullNameArray.append(object?.value(forKey: "FullName") as! String)
                                    self.sentUserImageArray.append(object?.value(forKey: "userImage") as! PFFile)
                                    
                                    self.sentStatusArray.append(status as! String)
                                    
                                    print(self.sentUserNameArray, "IKKM")
                                    print(self.sentStatusArray)
                                    completion(true)
                                    
                                    print("Loop JNADLDSASD")
                                    


                                    
                                }
                            })
                            
                        }
                        

                    }
                    completion(true)
                    
                }
                
            }
        }
        
        
    }
    
    func deleteFriendRequest(username: String, completion: @escaping (Bool) -> ()){
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: username)
        query.findObjectsInBackground { (object, error) in
            if error != nil{
                print("An error occurred")
                
            }else{
                print("ELSE!")
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
                                    print(object!, "OBJECT")
                                    print(userObj)
                                    for data in object! {
                                        
                                        data.deleteInBackground()
                                        
                                    }
                                    completion(true)
                                }
                            })
                        }
                    }
                }
                print("ELSE1")
            }
        }
        
        
        
        
    }
    
    
    
}
