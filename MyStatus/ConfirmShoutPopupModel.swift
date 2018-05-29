//
//  ConfirmShoutPopupModel.swift
//  MyStatus
//
//  Created by GKB on 5/27/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import Parse

class ConfirmShoutPopupModel{
    
    func sendShoutToUser(username: String, message: String){
        var fullName = PFUser.current()?.value(forKey: "FullName") as! String
        
        if fullName.characters.count >= 35{
            fullName = String(fullName.characters.prefix(20))
            fullName = "\(fullName)..."
        }
        let msg = "Shout from \(fullName) - \(message)"
        
        PFCloud.callFunction(inBackground: "sendPushToUser", withParameters: ["friendName" : username, "message": msg], block: { (success, error) in
            if error != nil {
                
                print(error!)
            }else {
                print("Push successfully sent to: \(username)")
            }
        })

    }
}
