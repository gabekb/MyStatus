//
//  UpdateStatusPageVC.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class UpdateStatusPageVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBAction func profilePicImageTapped(_ sender: Any) {
        
        print("Image tapped")
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
        

    }
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var extraDetailsTextView: UITextView!
    
    var status = ""
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var model = UpdateStatusPageVCModel()
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        if extraDetailsTextView.isFirstResponder{
            extraDetailsTextView.resignFirstResponder()
        }
        self.startActivityIndicator()
        var extraDetails = "None"
        if extraDetailsTextView.hasText{
            extraDetails = extraDetailsTextView.text!
        }
        
        model.updateStatus(status: status, extraDetails: extraDetails, image: profilePicImageView.image!) { (true) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            self.stopActivityIndicator()
            
            self.model.notifyFriends(status: self.status)
            
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    var pickerData = ["Free", "Busy", "at School", "at Work", "Sick", "Resting"]
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let valueSelected = pickerData[row] as String
        
        status = valueSelected
        if extraDetailsTextView.isFirstResponder{
            extraDetailsTextView.resignFirstResponder()
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return pickerData.count
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        status = "Free"
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateStatusPageVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateStatusPageVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        profilePicImageView.layer.borderWidth = 0
        profilePicImageView.layer.borderColor = UIColor.gray.cgColor
        profilePicImageView.layer.masksToBounds = false
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height/2
        profilePicImageView.clipsToBounds = true
        
        
        //bannerView.adUnitID = "ca-app-pub-2927420295620779/5662306447"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = UIColor(red: 252/255, green: 102/255, blue: 103/255, alpha: 1)
        
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil ),
            
            
            UIBarButtonItem(title: "Update Status", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UpdateStatusPageVC.saveButtonPressed(_:))),
        
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil )]
        
        
        toolBar.sizeToFit()
        
        extraDetailsTextView.inputAccessoryView = toolBar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
            print(self.view.frame.origin.y)
        }
    }

    var firstEdit = true
    func textViewDidBeginEditing(_ textView: UITextView) {
        if firstEdit == true{
            self.extraDetailsTextView.text = ""
            firstEdit = false
        }
        
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            profilePicImageView.image = image
            
            
        }else {
            print("There was a problem choosing the image")
        }
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
