//
//  LoginPageVCMode.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse
class LoginPageVCModel{
    
    //var loginPage = LoginPageVC()
    
    
    func logIn(username: String, password: String, completion: @escaping (Bool) -> ()){
        
        PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
            if error != nil {
                print("An error occurred")
                
                
                var displayErrorMessage = "Please try again later."
                if let errorMessage = (error! as NSError).userInfo["error"] {
                    
                    displayErrorMessage = errorMessage as! String
                }
                
                
                UIApplication.shared.endIgnoringInteractionEvents()
                UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: displayErrorMessage), animated: true, completion: nil)
                
            }else {
                
                
                let installation = PFInstallation.current()
                //installation?.setDeviceTokenFrom(deviceToken)
                installation?.setObject(PFUser.current()!, forKey: "user")
                installation?.saveInBackground()
                
                completion(true)
                
            }
        })

        
        
        
        
        
    }
    
}
