//
//  FriendStatusPageVCViewController.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class FriendStatusPageVCViewController: UIViewController, GADBannerViewDelegate {
    var num = 0
    
    @IBOutlet weak var removeUserButton: UIButton!
    
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var friendStatusLabel: UILabel!
    
    @IBAction func removeUserButtonPressed(_ sender: Any) {
        
       self.performSegue(withIdentifier: "removeUserPopup", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "removeUserPopup"{
            
            let removeVC = segue.destination as! RemoveUserPopup
            
            removeVC.userName = self.friendUserName
        }
        
            
    }
    var refresher = UIRefreshControl()

    
    
    
    var friendNameDisplay:String = ""
    var friendStatusDisplay:String = ""
    var friendExtraDetails:String = ""
    var friendUserName:String = ""
    
    @IBAction func backToHomePagePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var isMenuShowing = false
    
    var model = FriendStatusPageVCModel()
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var extraDetailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        removeUserButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
        self.startActivityIndicator()
        removeUserButton.isEnabled = false
        print(friendExtraDetails)
        // Do any additional setup after loading the view.
        friendNameLabel.text = friendNameDisplay
        friendStatusLabel.text = friendStatusDisplay
        extraDetailsTextView.text = friendExtraDetails
        userNameLabel.text = friendUserName
        self.stopActivityIndicator()
        removeUserButton.isEnabled = true
        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
