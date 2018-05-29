//
//  LandingPageVC.swift
//  MyStatus
//
//  Created by GKB on 5/29/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit

class LandingPageVC: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        createAccountButton.layer.borderColor = UIColor(red: 249/255, green: 116/255, blue: 107/255, alpha: 1).cgColor
        createAccountButton.layer.borderWidth = 1
            
            //

        // Do any additional setup after loading the view.
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
