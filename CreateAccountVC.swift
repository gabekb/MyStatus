//
//  CreateAccountVC.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountVC.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountVC.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        UITextField.formatTextFieldLines(textfield: fullNameTextField)
        UITextField.formatTextFieldLines(textfield: userNameTextField)
        
        UITextField.formatTextFieldLines(textfield: passwordTextField)
        UITextField.formatTextFieldLines(textfield: emailTextField)
    }
    @IBOutlet weak var fullNameTextField: UITextField!

    @IBOutlet weak var userNameTextField: UITextField!
    
     @IBOutlet weak var passwordTextField: UITextField!
     @IBOutlet weak var emailTextField: UITextField!
    
    var model = CreateAccountVCModel()
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        
        self.startActivityIndicator()
        
        if fullNameTextField.hasText && userNameTextField.hasText && passwordTextField.hasText && emailTextField.hasText {
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            let userName = userNameTextField.text!
            
            model.createAccount(username: userName.lowercased(), password: passwordTextField.text!, email: emailTextField.text!, fullName: fullNameTextField.text!, completion: { (true) in
                UIApplication.shared.endIgnoringInteractionEvents()
                self.stopActivityIndicator()
                
                self.performSegue(withIdentifier: "createAccountToUserStatusPage", sender: self)
            })
            self.stopActivityIndicator()
            
        }else {
            
            presentAlert(errorMessage: "Please enter information in all of the fields.")
            self.stopActivityIndicator()
            
        }
    }
    
    
    
    
    func presentAlert(errorMessage: String) {
        
        let alert = UIAlertController.alertControllerWithTitle(title: "Error", message: errorMessage)
        self.present(alert, animated: true, completion: {
            
        })
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
            let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.height
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.window?.frame.origin.y = -1 * 100
                self.view.layoutIfNeeded()
            })
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.window?.frame.origin.y = 0
                self.view.layoutIfNeeded()
                
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
