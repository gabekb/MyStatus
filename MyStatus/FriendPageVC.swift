//
//  FriendPageVC.swift
//  MyStatus
//
//  Created by GKB on 5/24/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import Parse

var sentInSession = [String]()
class FriendPageVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var userFriends = [String]()
    var friendStatus = [String]()
    var model = FriendStatusVCModel()
    var extraDetails = [String]()
    var refresher = UIRefreshControl()
    var friendUserName = String()
    var friendFullName = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        num = indexPath.row
        self.performSegue(withIdentifier: "toFriendPage", sender: self)
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        print(userFriends.count)
        return userFriends.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendStatusCell
        
        cell.nameLabel.text = userFriends[indexPath.row]
        cell.statusLabel.text = friendStatus[indexPath.row]
        
        if friendStatus[indexPath.row] == "Free"{
            cell.statusLabel.textColor = UIColor(red: 30/255, green: 130/255, blue: 76/255, alpha: 1)
            
            if sentInSession.contains(friendUserNames[indexPath.row]) == false{
                cell.shoutButton.tag = indexPath.row
                cell.shoutButton.isHidden = false
                cell.shoutButton.isEnabled = true
            }else{
                cell.shoutButton.isEnabled = false
                cell.shoutButton.isHidden = true
            }
            
            
            cell.shoutButton.addTarget(self,action:#selector(shoutButtonPressed(sender:)), for: .touchUpInside)
        }else {
            cell.shoutButton.isEnabled = false
            cell.shoutButton.isHidden = true
            cell.statusLabel.textColor = UIColor.red
        }
        
        
        self.friendImages[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let dowloadedImage = UIImage(data: imageData) {
                    
                    cell.friendImage.image = dowloadedImage
                    
                }
            }
        }
        
        cell.friendImage.layer.borderWidth = 0
        cell.friendImage.layer.borderColor = UIColor.gray.cgColor
        cell.friendImage.layer.masksToBounds = false
        cell.friendImage.layer.cornerRadius = cell.friendImage.frame.height/2
        cell.friendImage.clipsToBounds = true
        
        
        
        
        return cell
        
    }
    
    @objc func shoutButtonPressed(sender:UIButton) {
        //UIApplication.shared.beginIgnoringInteractionEvents()
        
        let buttonRow = sender.tag
        
        friendUserName = String(friendUserNames[buttonRow])
        friendFullName = String(userFriends[buttonRow])
        
        if sentInSession.contains(friendUserName) == false{
            self.performSegue(withIdentifier: "confirmShoutPopup", sender: self)
        }else{
            print("Already sent push")
        }
        
        
        
        
    }
    
    var friendUserNames = [String]()
    var friendImages = [PFFile]()
    
    var newFriends = [String]()
    @objc func getFriendInfo(){
                
        model.checkForAcceptedFriendRequests(){ (true) in
            self.newFriends = self.model.newFriends
            self.addFriends(completion: {(true) in
                
                print(self.newFriends, "TESTafdsgafgasfdasfdafdafsdfsaasfsdfaasfd")
                self.newFriends.removeAll()
                self.model.newFriends.removeAll()
                
                
                self.model.queryForFriendInfo(completion: {(true) in
                    self.userFriends.removeAll()
                    self.friendStatus.removeAll()
                    self.extraDetails.removeAll()
                    self.friendUserNames.removeAll()
                    self.friendImages.removeAll()
                    
                    self.friendUserNames = self.model.userFriendsNames
                    self.userFriends = self.model.userFriends
                    self.friendStatus = self.model.friendStatus
                    self.extraDetails = self.model.extraDetails
                    self.friendImages = self.model.friendPhoto
                    
                    self.stopActivityIndicator()
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    print("Got info??")
                    
                })
                
            })
            
        }

        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFriendPage" {
            let FSVC = segue.destination as! FriendStatusPageVCViewController
            
            FSVC.friendNameDisplay = userFriends[num]
            FSVC.friendStatusDisplay = friendStatus[num]
            FSVC.friendExtraDetails = extraDetails[num]
            FSVC.friendUserName = friendUserNames[num]
            FSVC.num = num
            
            print(num, "THIS IS THE FIRST NUM")
            print(extraDetails[num])
        }else if segue.identifier == "confirmShoutPopup" {
            let CSVC = segue.destination as! ConfirmShoutPopup
            
            CSVC.userName = friendUserName
            CSVC.fullName = friendFullName
            
        }
    }

    
    var num = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.reloadData()
        
        refresher = UIRefreshControl()
        
        
        refresher.addTarget(self, action: #selector(getFriendInfo), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            
            tableView.addSubview(refresher)
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getFriendInfo()
        tableView.reloadData()
    
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
