//
//  UserStatusPageVC.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class UserStatusPageVC: UIViewController, GADBannerViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, BWWalkthroughViewControllerDelegate{

    @IBAction func profilePicTapped(_ sender: Any) {
        
        print("Image tapped")
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        let signOutAlert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.alert)
        
        signOutAlert.addAction(UIAlertAction(title: "I'm Sure", style: .default, handler: { (action: UIAlertAction!) in
            self.startActivityIndicator()
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.model.signOut{ (true) in
                
                
                self.stopActivityIndicator()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LandingPageVC")
                
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
                UIApplication.shared.endIgnoringInteractionEvents()
                
            }

            
        }))
        
        signOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            signOutAlert.dismiss(animated: true, completion: nil)
        }))

        present(signOutAlert, animated: true, completion: nil)

    }
    
    
    
    @IBOutlet weak var mainView: UIView!
    
    
    
    @IBOutlet weak var extraDetailsTextView: UITextView!
    
    
    
    
   
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBOutlet weak var userInfoLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.startActivityIndicator()
        refresh()
    }
    
    var model = UserStatusPageVCModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        let fullName = model.getFullName()
        let userName = model.getUserName()
        
        let infoLabel = "\(fullName) (\(userName))"
        userInfoLabel.text = infoLabel
        
        let imageFile = PFUser.current()?.value(forKey: "userImage") as! PFFile
        
        imageFile.getDataInBackground { (data, error) in
            if error != nil{
              print("Profile pic could not be obtained")
            }else{
                let profImage = UIImage(data: data!)
          
                self.profilePicImageView.image = profImage
                print(PFUser.current()?.value(forKey: "userImage"))
                
                
                
            }
        }
        
        
        
        profilePicImageView.layer.borderWidth = 0
        profilePicImageView.layer.borderColor = UIColor.gray.cgColor
        profilePicImageView.layer.masksToBounds = false
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height/2
        profilePicImageView.clipsToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
                

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    var newFriends = [String]()

    func refresh() {
        
        var userStatus = ""
        userStatus = model.getUserStatus { (true) in
            self.statusLabel.text = (self.model.userStatus as! String)
            self.extraDetailsTextView.text = self.model.userExtraDetails
        }
        statusLabel.text = userStatus
        
        model.checkForAcceptedFriendRequests(){ (true) in
            self.newFriends = self.model.newFriends
            self.addFriends(completion: {(true) in
                
                print(self.newFriends, "TESTafdsgafgasfdasfdafdafsdfsaasfsdfaasfd")
                self.newFriends.removeAll()
                self.model.newFriends.removeAll()
                self.stopActivityIndicator()
            })
            
        }
    self.stopActivityIndicator()
        
        
    }
    
    func addFriends(completion: @escaping (Bool) -> ()){
        print(self.newFriends)
        var counter = 0
        for item in self.newFriends{
            counter+=1
            self.model.addFriendByUserName(userName: item, completion: { (true) in
                self.model.changeReqStatus(toUser: item, newStatus: "Accepted & Confirmed") { (true) in
                    print("Request status changed")
                    if counter == self.newFriends.count{
                        
                        completion(true)
                        self.newFriends.removeAll()
                        return
                    }
                    print(counter)
                    
                }
            })
            
        }
        completion(true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            profilePicImageView.image = image
            model.saveProfilePic(image: image)
            
        }else {
            print("There was a problem choosing the image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func walkthroughCloseButtonPressed() {
        UserDefaults.standard.set(false, forKey: "FirstLaunch")
        self.dismiss(animated: true, completion: nil)
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
