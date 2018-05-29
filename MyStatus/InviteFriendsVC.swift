//
//  InviteFriendsVC.swift
//  MyStatus
//
//  Created by GKB on 4/24/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import MessageUI
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit



class InviteFriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,  MFMailComposeViewControllerDelegate, FBSDKAppInviteDialogDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addByUserNameButton: UIButton!
    @IBOutlet weak var viewFRQButton: UIButton!

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 3
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textMsgCell", for: indexPath)
            return cell
            
        }else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "facebookCell", for: indexPath)
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath)
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            sendTextMessageButtonTapped()
            
        }else if indexPath.row == 1{
            FBinviteButtonTapped()
        }
        else if indexPath.row == 2{
            self.performSegue(withIdentifier: "toEmailPopup", sender: self)
            
        }
    }
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*addByUserNameButton.layer.borderWidth = 1
        addByUserNameButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        viewFRQButton.layer.borderWidth = 1
        viewFRQButton.layer.borderColor = UIColor.lightGray.cgColor*/
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    let messageComposer = MessageComposer()
    
    func sendTextMessageButtonTapped() {
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "Your device can not send messages."), animated: true, completion: nil)
        }
    }
    
    
    func FBinviteButtonTapped()
    {
        print("Invite button tapped")
        
        let inviteDialog:FBSDKAppInviteDialog = FBSDKAppInviteDialog()
        if(inviteDialog.canShow()){
            
            let appLinkUrl:NSURL = NSURL(string: "https://fb.me/217589335402764")!
            //let previewImageUrl:NSURL = NSURL(string: "http://yourwebpage.com/preview-image.png")!
            
            let inviteContent:FBSDKAppInviteContent = FBSDKAppInviteContent()
            inviteContent.appLinkURL = appLinkUrl as URL!
            //inviteContent.appInvitePreviewImageURL = previewImageUrl as URL!
            
            inviteDialog.content = inviteContent
            inviteDialog.delegate = self
            inviteDialog.show()
        }
    }
    
    
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!){
        
        
        if let resultObject = (dictionary: results) as? NSDictionary{
            if let didCancel = resultObject.value(forKey: "completionGesture")
            {
                if (didCancel as AnyObject).caseInsensitiveCompare("Cancel") == ComparisonResult.orderedSame
                {
                    print("User Canceled invitation dialog")
                }
            }
            
        }
        
        
        
    }
    
    
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!){
        print("Error tool place in appInviteDialog \(error)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
