//
//  RoundedShadowView.swift
//  Arkan
//
//  Created by BinaryCase on 1/2/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {
        
        override func awakeFromNib() {
            setupView()
        }
        
        func setupView() {
            self.layer.cornerRadius =  11//self.frame.height / 10
            self.layer.shadowOpacity = 0.3
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowRadius = 5.0
            self.layer.shadowOffset = CGSize(width: 0, height: 5)
        }
        
}

