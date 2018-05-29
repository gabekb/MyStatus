//
//  RemoveUserPopup.swift
//  MyStatus
//
//  Created by GKB on 4/29/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit

class RemoveUserPopup: UIViewController {

    var userName = ""
    var model = RemoveUserPopupModel()
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        model.removeFriend(username: userName){ (true) in
            self.performSegue(withIdentifier: "backToRootFriendInfo", sender: self)
            //self.dismiss(animated: true, completion: nil)
            
        }
    
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userNameLabel.text = userName
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
