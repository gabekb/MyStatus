//
//  TextFieldLines.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit

extension UITextField {
    class func formatTextFieldLines(textfield: UITextField) {
        
        let topLine = CALayer()
        topLine.frame = CGRect(origin: CGPoint(x: 0, y:textfield.frame.height - 1), size: CGSize(width: textfield.frame.width, height:  1))
        topLine.backgroundColor = UIColor.lightGray.cgColor
        textfield.borderStyle = UITextBorderStyle.none
        textfield.layer.addSublayer(topLine)
        
    }
}
