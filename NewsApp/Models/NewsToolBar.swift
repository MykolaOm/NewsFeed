//
//  NewsToolBar.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 30.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import UIKit

class NewsToolBar: UIToolbar {
    
    var textField : UITextField!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //        self.frame = CGRect(x:0,y:35,width:(superview?.frame.width)!,height:50)
        self.sizeToFit()
        self.barTintColor = .orange
        self.isTranslucent = false
        self.tintColor = .white
        setItems()
        
    }
    
    
    func setItems() {
        let fixed = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
        fixed.width = 10
        
        //Text
        //        let text = UIBarButtonItem(title: "My Title", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        let label = UILabel(frame: CGRect(x:0,y:0,width:50,height:30))
        label.text = "My Label"
        label.textColor = .white
        
        // cleanup needed!---------------------------------
        let ley = UIBarButtonItem(customView: label)
//        let lala = UIBarButtonItem(title: "MyTitle", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        //TextField
        textField = UITextField(frame: CGRect(x:0,y:0,width:150,height:30))
        textField.delegate = superview.self as? UITextFieldDelegate
        textField.textColor = .blue
        //        text
        let border = CALayer()
        let width : CGFloat = 2.0
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x:0,y: textField.frame.size.height-width, width:textField.frame.size.width,height: textField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        let textFieldButton = UIBarButtonItem(customView: textField)
        textField.isHidden = true
        //Search Button
        let search = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: nil)
        
        //Flexible Space
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        self.items = [fixed, ley, fixed, textFieldButton, flexible, search]
    }
    
}
