//
//  ButtonRounded.swift
//  Elsawy
//
//  Created by Tariq Maged on 3/5/19.
//  Copyright © 2019 Tariq Maged. All rights reserved.
//

import UIKit

class ButtonRounded: UIButton {
    

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.height/4
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

}
