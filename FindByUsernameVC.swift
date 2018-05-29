//
//  FindByUsernameVC.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit

class FindByUsernameVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    var model = FindByUsernameModel()
    var userFullName = ""
    
    @IBAction func addUserPressed(_ sender: Any) {
        if textField.hasText{
            
            let userSearchedFor = textField.text!.lowercased()
            
            
            model.createRequest(toUser: userSearchedFor){ (true) in
                self.model.sendNotifyPush(userName: userSearchedFor)
                
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.becomeFirstResponder()
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
