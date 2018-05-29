//
//  EnterEmailPopup.swift
//  MyStatus
//
//  Created by GKB on 4/30/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import MessageUI
import Parse

class EnterEmailPopup: UIViewController, MFMailComposeViewControllerDelegate {

    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        if emailAddressTextField.text != nil{
            if isValidEmail(testStr: emailAddressTextField.text!) == true{
                
                print("Valid email entered")
                sendEmail(emailAddress: emailAddressTextField.text!)
                
                
            }else{
                UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "Please enter a valid email address"), animated: true, completion: nil)
            }
        }else{
            UIApplication.topViewController()?.present(UIAlertController.alertControllerWithTitle(title: "Error", message: "Please enter an email address."), animated: true, completion: nil)
        }
        
        
    }
    
    func sendEmail(emailAddress: String) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let fullName = PFUser.current()?.value(forKey: "FullName")
        let username = PFUser.current()?.value(forKey: "username")
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["\(emailAddress)"])
        composeVC.setSubject("\(fullName!) has invited you to join myStatus!")
        composeVC.setMessageBody("myStatus is an application that allows you to let your friends, family, or even Co-workers easily know when you're busy or free. With the tap of a button, you can instantly notify them about your current status. Add me by my username: \(username!). myStatus is available for download on the App Store via this link: https://itunes.apple.com/app/id1231893958", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }

    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailAddressTextField.becomeFirstResponder()
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
