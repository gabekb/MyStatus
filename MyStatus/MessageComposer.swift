//
//  MessageComposer.swift
//  MyStatus
//
//  Created by GKB on 4/30/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import Foundation
import MessageUI
import Parse

let textMessageRecipients = [String]() // for pre-populating the recipients list

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    let currentUserName = PFUser.current()?.username!
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body =  "myStatus is an app that allows you notify your friends, family, and even co-workers about your current status with a tap of a button. Download myStatus on the App Store and add me by the username: \(currentUserName!)  https://itunes.apple.com/app/id1231893958"
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
