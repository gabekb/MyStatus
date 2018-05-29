//
//  MainTabBarVC.swift
//  MyStatus
//
//  Created by GKB on 5/29/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import Parse

class MainTabBarVC: UITabBarController, UITabBarControllerDelegate, BWWalkthroughViewControllerDelegate {
var cameFromTutorial = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendBadge()
        getFRQBadge()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "FirstLaunch") == nil {
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let walkthrough = stb.instantiateViewController(withIdentifier: "walkthrough") as! BWWalkthroughViewController
            let page_one = stb.instantiateViewController(withIdentifier: "page_1")
            let page_two = stb.instantiateViewController(withIdentifier: "page_2")
            let page_three = stb.instantiateViewController(withIdentifier: "page_3")
            
            
            // Attach the pages to the master
            walkthrough.delegate = self as BWWalkthroughViewControllerDelegate
            
            walkthrough.add(viewController: page_one)
            walkthrough.add(viewController: page_two)
            walkthrough.add(viewController: page_three)
            
            self.present(walkthrough, animated: true, completion: nil)
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
        }
        if cameFromTutorial == true{
            //self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?.index(of: 2)\
            self.selectedIndex = 2
            print("SELECTED INDEX")
        }

        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[1]{
            if tabBar.items?[1].badgeValue != nil || tabBar.items?[1].badgeValue != "0"{
                tabBar.items?[1].badgeValue = nil
                resetFriendBadge()

            }
        }else if item == tabBar.items?[2]{
            if tabBar.items?[2].badgeValue != nil || tabBar.items?[2].badgeValue != "0"{
                tabBar.items?[2].badgeValue = nil
                resetFRQBadge()
            }
            
        }
    }
    func getFriendBadge(){
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: PFUser.current()?.username!)
        query.findObjectsInBackground { (object, error) in
            if error != nil{
                print(error!)
            }else{
                if let obj = object{
                    for item in obj {
                        if let z = item as? PFObject{
                            if let friendBadge = z["FriendBadge"] as? Int{
                                if friendBadge != nil{
                                    if friendBadge == 0{
                                        self.tabBar.items?[1].badgeValue = nil
                                    }else{
                                        self.tabBar.items?[1].badgeValue = "\(friendBadge)"
                                    }
                                    
                                }
                            }
                            
                            
                        }
                    }
                }
                
                
            }
        }
    }
    func resetFriendBadge(){
        let user = PFUser.current()
        user?.setValue(0, forKey: "FriendBadge")
        user?.saveInBackground(block: { (success, error) in
            if error != nil{
                print(error!)
            }else{
                print("Successful")
            }
        })
    }
    func getFRQBadge(){
        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: PFUser.current()?.username!)
        query.findObjectsInBackground { (object, error) in
            if error != nil{
                print(error!)
            }else{
                if let obj = object{
                    for item in obj {
                        if let z = item as? PFObject{
                            if let friendBadge = z["FReqBadge"] as? Int{
                                if friendBadge != nil{
                                    if friendBadge == 0 {
                                        self.tabBar.items?[2].badgeValue = nil
                                    }else{
                                        self.tabBar.items?[2].badgeValue = "\(friendBadge)"
                                        
                                    }
                                    
                                }
                            }
                            
                            
                        }
                    }
                }
                
                
            }
        }
    }
    func resetFRQBadge(){
        let user = PFUser.current()
        user?.setValue(0, forKey: "FReqBadge")
        user?.saveInBackground(block: { (success, error) in
            if error != nil{
                print(error!)
            }else{
                print("Successful")
            }
        })
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
