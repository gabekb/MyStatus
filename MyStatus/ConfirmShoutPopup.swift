//
//  ConfirmShoutPopup.swift
//  MyStatus
//
//  Created by GKB on 5/27/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import Parse

class ConfirmShoutPopup: UIViewController, UITextViewDelegate {
    @IBOutlet weak var userNameLabel: UILabel!
    var model = ConfirmShoutPopupModel()
    
    @IBOutlet weak var customTextView: UITextView!
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        var message = "Let's hang out! Call or message me to make plans if you're available."
        if customTextView.text != "Add a custom message (Ex: Meet me at the coffee shop at 3:00)" && customTextView.hasText{
            message = customTextView.text
            model.sendShoutToUser(username: userName, message: message)
            sentInSession.append(userName)
            self.dismiss(animated: true, completion: nil)
        }else{
            model.sendShoutToUser(username: userName, message: message)
            sentInSession.append(userName)
            self.dismiss(animated: true, completion: nil)
        }
        
            
        }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var userName = String()
    var fullName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = userName
        customTextView.delegate = self
        let fullname = PFUser.current()?.value(forKey: "FullName") as! String
        if fullname.characters.count < 35{
            var length = fullname.characters.count
            charCount -= length
            print(charCount)
        }else{
            charCount -= 20
        }
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmShoutPopup.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmShoutPopup.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var charCount = 100
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < charCount;
    }
    
    var firstEdit = true
    func textViewDidBeginEditing(_ textView: UITextView) {
        if firstEdit == true{
          self.customTextView.text = ""
            firstEdit = false
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 50
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
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
