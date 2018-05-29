//
//  ResetPasswordVC.swift
//  MyStatus
//
//  Created by GKB on 5/1/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import Parse

class ResetPasswordVC: UIViewController {
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func sendPasswordResetButtonPressed(_ sender: Any) {
        
        if emailTextField.hasText {
            if isValidEmail(testStr: emailTextField.text!) == true{
                PFUser.requestPasswordResetForEmail(inBackground: emailTextField.text!) { (success, error) in
                    if error != nil{
                        
                        print("Failed")
                        var displayErrorMessage = "Please try again later."
                        if let errorMessage = (error! as NSError).userInfo["error"] {
                            
                            displayErrorMessage = errorMessage as! String
                        }
                        self.self.presentAlert(errorMessage: displayErrorMessage, title: "Error")

                        
                    }else{
                        print("Reset email sent successfully")
                        
                        let alertController = UIAlertController(title: "Check your email.", message: "Your password reset link has been sent successfully.", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler:{
                            action in
                            
                            UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                            
                            })

                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                       
                    }
                }
                
            }else{
                presentAlert(errorMessage: "Please enter a valid email.", title: "Error")
            }
            
        }else{
            self.presentAlert(errorMessage: "Please enter the email address associated with the account.", title: "Error")
            
        }
        
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentAlert(errorMessage: String, title: String) {
        
        let alert = UIAlertController.alertControllerWithTitle(title: title, message: errorMessage)
        self.present(alert, animated: true, completion: {
            
        })
        
        
    }
    
    override func viewDidLayoutSubviews() {
        UITextField.formatTextFieldLines(textfield: emailTextField)
        
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
