//
//  CreateAccountVCModel.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse

class CreateAccountVCModel{
    
    func createAccount(username:String, password: String, email: String, fullName: String, completion: @escaping (Bool) -> ()){
        
        let user = PFUser()
        
        
        
        
        
        
        //user.relatio
        user.username = username
        
        user.password = password
        
        user.email = email
        
        user.setValue(fullName, forKey: "FullName")
        
        user.setValue("Not Set", forKey: "Status")
        
        user.setValue("None", forKey: "ExtraDetails")
        
        let imageData = UIImageJPEGRepresentation(UIImage(named: "empty-profile")!, 0.6)
        
        let imageFile = PFFile(name: "Default Picture", data: imageData!)
        
        user.setValue(imageFile, forKey: "userImage")
        
        user.signUpInBackground { (success, error) in
            if error != nil {
                
                
                
                var displayErrorMessage = "Please try again later."
                if let errorMessage = (error! as NSError).userInfo["error"] {
                    
                    displayErrorMessage = errorMessage as! String
                }
                
                UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: displayErrorMessage), animated: true, completion: nil)
                UIApplication.shared.endIgnoringInteractionEvents()
                
                
            }else {
                let installation = PFInstallation.current()
                //installation?.setDeviceTokenFrom(deviceToken)
                installation?.setObject(PFUser.current()!, forKey: "user")
                installation?.saveInBackground()
                completion(true)
            }
        }

        
        
        
        
        
    }
    
}
