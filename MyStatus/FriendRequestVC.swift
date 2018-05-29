//
//  FriendRequestVC.swift
//  MyStatus
//
//  Created by GKB on 4/27/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds


class FriendRequestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var recievedFriendReqTable: UITableView!
    
    @IBOutlet weak var sentFriendReqTable: UITableView!
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let model = FriendRequestVCModel()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == recievedFriendReqTable{
            return RfullNameArray.count
        }else {
            
            return SfullNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == recievedFriendReqTable{
            
            return 66
        }else{
            
           return 66
            
        }
        
    }
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == recievedFriendReqTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recievedFriendReqCell", for: indexPath) as! RecievedFRQCell
            cell.fullNameLabel.text = RfullNameArray[indexPath.row]
            cell.userNameLabel.text = RuserNameArray[indexPath.row]
            
            
            if self.RuserImage[indexPath.row] != nil{
                self.RuserImage[indexPath.row].getDataInBackground { (data, error) in
                    
                    if let imageData = data {
                        
                        if let dowloadedImage = UIImage(data: imageData) {
                            
                            cell.RuserImageView.image = dowloadedImage
                            
                        }
                    }
                }
            }else{
                cell.RuserImageView.image = UIImage(named: "empty-profile")
            }
        
            
            cell.RuserImageView.layer.borderWidth = 0
            cell.RuserImageView.layer.borderColor = UIColor.gray.cgColor
            cell.RuserImageView.layer.masksToBounds = false
            cell.RuserImageView.layer.cornerRadius = cell.RuserImageView.frame.height/2
            cell.RuserImageView.clipsToBounds = true
            
            
            cell.acceptButton.tag = indexPath.row
            
            
            cell.acceptButton.addTarget(self,action:#selector(acceptButtonClicked(sender:)), for: .touchUpInside)

            cell.rejectButton.tag = indexPath.row
            
            
            cell.rejectButton.addTarget(self,action:#selector(rejectButtonClicked(sender:)), for: .touchUpInside)
            
            return cell
            
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sentFriendReqCell", for: indexPath) as! SentFRQCell
            
            if self.SuserImage[indexPath.row] != nil{
                self.SuserImage[indexPath.row].getDataInBackground { (data, error) in
                    
                    if let imageData = data {
                        
                        if let dowloadedImage = UIImage(data: imageData) {
                            
                            cell.SuserImageView.image = dowloadedImage
                            
                        }
                    }
                }
            }else{
                cell.SuserImageView.image = UIImage(named: "empty-profile")
            }
            
            
            cell.SuserImageView.layer.borderWidth = 0
            cell.SuserImageView.layer.borderColor = UIColor.gray.cgColor
            cell.SuserImageView.layer.masksToBounds = false
            cell.SuserImageView.layer.cornerRadius = cell.SuserImageView.frame.height/2
            cell.SuserImageView.clipsToBounds = true
            
            
            if SstatusArray[indexPath.row] == "Accepted & Confirmed" {
                cell.SfullNameLabel.text = SfullNameArray[indexPath.row]
                
                cell.SStatusLabel.text = "Accepted"
                
                cell.SUserNameLabel.text = SuserNameArray[indexPath.row]
                
                
                
                
            }else {
                
                cell.SfullNameLabel.text = SfullNameArray[indexPath.row]
                
                cell.SStatusLabel.text = SstatusArray[indexPath.row]
                
                cell.SUserNameLabel.text = SuserNameArray[indexPath.row]
                
                
            }
            
            
            
            
            return cell
        }
        
        
        
    }
    
    @objc func rejectButtonClicked(sender:UIButton) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let buttonRow = sender.tag
        
        let userName = RuserNameArray[buttonRow]
        print(RfullNameArray, "RSTATUSARRAY")
        
        model.deleteFriendRequest(username: userName){(true) in
            print("CLICKED")
            print(buttonRow, "BUTTONROW")
            self.RfullNameArray.remove(at: buttonRow)
            self.RuserNameArray.remove(at: buttonRow)
            self.RuserImage.remove(at: buttonRow)
            
            self.recievedFriendReqTable.reloadData()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
    }
    
    @objc func acceptButtonClicked(sender:UIButton) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let buttonRow = sender.tag
        
        let userName = RuserNameArray[buttonRow]
        
        model.addFriendByUserName(userName: userName){(true) in
            
            self.RfullNameArray.remove(at: buttonRow)
            self.RstatusArray.remove(at: buttonRow)
            self.RuserNameArray.remove(at: buttonRow)
            self.RuserImage.remove(at: buttonRow)
            
            
            
            self.model.changeReqStatus(fromUser: userName, newStatus: "Accepted"){(true) in
                self.recievedFriendReqTable.reloadData()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
        }
    }
    
    var RfullNameArray = [String]()
    var RstatusArray = [String]()
    var RuserNameArray = [String]()
    var RuserImage = [PFFile]()
    
    var SfullNameArray = [String]()
    var SstatusArray = [String]()
    var SuserNameArray = [String]()
    var SuserImage = [PFFile]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startActivityIndicator()
        
        
        
        sentFriendReqTable.separatorInset = .zero
        sentFriendReqTable.layoutMargins = .zero
        
        recievedFriendReqTable.separatorInset = .zero
        recievedFriendReqTable.layoutMargins = .zero
        
        
        
        
        model.getRecievedFriendReq{ (true) in
            
            self.RfullNameArray = self.model.fullnameArray
            self.RstatusArray = self.model.statusArray
            self.RuserNameArray = self.model.usernameArray
            self.RuserImage = self.model.imageFileArray
            
            self.stopActivityIndicator()
            self.recievedFriendReqTable.reloadData()
            
            
        }
        
        model.getSentFriendReq { (true) in
            self.SfullNameArray = self.model.sentFullNameArray
            self.SstatusArray = self.model.sentStatusArray
            self.SuserNameArray = self.model.sentUserNameArray
            self.SuserImage = self.model.sentUserImageArray
            
            self.stopActivityIndicator()
            self.sentFriendReqTable.reloadData()
        }
        // Do any additional setup after loading the view.
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
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
