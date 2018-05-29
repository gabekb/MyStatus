//
//  UserStatusPageVCModel.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse

class UserStatusPageVCModel{
    
    var userStatus = PFUser.current()?.value(forKey: "Status")
    var userExtraDetails = ""
    var usersname:String = ""

    func getUserStatus(completion: @escaping (Bool) -> ())-> String{
        
        //let query = PFQuery(className: "_User")
        
        let query : PFQuery = PFUser.query()!
        
        
        
        var userData = [String]()
        
        
        let userObjectID = PFUser.current()?.objectId!
        
        query.whereKey("objectId", equalTo: userObjectID!)
        
        
        query.findObjectsInBackground { (object, error) in
            if error != nil {
                print("Error Occurred obtaining status")
            }else {
                
                if let userInfo = object {
                    
                    for object in userInfo{
                        
                        if let item = object as? PFObject {

                            self.userStatus = item["Status"]
                            self.userExtraDetails = item["ExtraDetails"] as! String
                            completion(true)
                        }
                        
                    }
                    
                    
                }
            }
        }
        return userStatus! as! String
        
    }
    
    
    func getFullName() -> String{
        let fullName = PFUser.current()?.value(forKey: "FullName")
        return fullName as! String
    }
    
    func getUserName() -> String{
        let username = PFUser.current()?.value(forKey: "username")
        return username as! String
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
    
    func signOut(completion: @escaping (Bool) -> ()) {
        
        PFUser.logOutInBackground { (error) in
            if error != nil {
                print("An error occurred.")
                //stopActivityIndicator()
                UIApplication.shared.endIgnoringInteractionEvents()

            }else {
                
                print("Signed out successfully")
                completion(true)
            }
        }
        
    }
    
    
    
    
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
    
    func profilePicSetup(profilePicImage: UIImageView) {
        
        
        profilePicImage.layer.borderWidth = 1
        profilePicImage.layer.borderColor = UIColor.gray.cgColor
        profilePicImage.layer.masksToBounds = false
        profilePicImage.layer.cornerRadius = profilePicImage.frame.height/2
        profilePicImage.clipsToBounds = true
        
        let query : PFQuery = PFUser.query()!
        
        query.getObjectInBackground(withId: (PFUser.current()?.objectId)!, block: { (object, error) in
            if error != nil {
                print("An error occurred")
                
                
            }else {
                
                if object?["userImage"] != nil {
                    
                    let imageData = object?["userImage"] as! PFFile
                    imageData.getDataInBackground(block: { (data, error) in
                        if error != nil {
                            print("error")
                            
                        }else {
                            profilePicImage.image = UIImage(data: data!)
                            
                            
                            print("Profile pic sucessfully retrieved.")
                            
                        }
                    })
                    
                }else {
                    print("No image was found")
                }
                
                
                
            }
        })
        
        
        
    }
    
    func saveProfilePic(image: UIImage){
        let user = PFUser.current()
        
        if image != UIImage(named: "empty-profile.png"){
            let imageData = UIImageJPEGRepresentation(image, 0.6)
            
            let imageFile = PFFile(name: "image.png", data: imageData!)
            user?.setValue(imageFile, forKey: "userImage")
            
        }
        
        user?.saveInBackground(block: { (success, error) in
            if error != nil {
                print("An error occurred")
            }else{
                print("Saved profile pic successfully")
            }
        })
    }

    /*func testPush() {
        
        PFCloud.callFunction(inBackground: "sendPushToUser", withParameters: ["recipientId": PFUser.current()?.objectId!, "message" : "Test notification"]) { (success, error) in
            if error != nil {
                print("error occurred")
            }else {
                print("Sent successfully")
            }
        }
    }*/
}
