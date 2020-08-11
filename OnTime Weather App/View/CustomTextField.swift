//
//  CustomTextField.swift
//  Arkan
//
//  Created by BinaryCase on 1/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
  
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 11
        layer.borderWidth = 1.0
        layer.borderColor = #colorLiteral(red: 0.1490012705, green: 0.1490328312, blue: 0.148994565, alpha: 1)
    }
        let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        override open func textRect(forBounds bounds: CGRect) -> CGRect {
       return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           return UIEdgeInsetsInsetRect(bounds, padding)
          //  return bounds.UIEdgeInsetsInsetRect(by: padding)

        }
        
        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
           // return bounds.inset(by: padding)

        }
    
   

}
