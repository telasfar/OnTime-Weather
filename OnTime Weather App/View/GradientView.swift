//
//  GradientView.swift
//  Elsawy
//
//  Created by Tariq Maged on 4/14/19.
//  Copyright © 2019 Tariq Maged. All rights reserved.
//


import UIKit

@IBDesignable //el 7agat deh hat2asar fe el storyboard
class GradientView: UIView {
   /*
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    private var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    @IBInspectable var topColor: UIColor = .white { didSet { updateColors() } }
    @IBInspectable var bottomColor: UIColor = .blue { didSet { updateColors() } }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateColors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateColors()
    }
    
    private func updateColors() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
    
   */
    @IBInspectable var topColor:UIColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1) {
        didSet { //teshta3'al abl mane3mel set le var
            self.setNeedsLayout() //2e3mel update le shakl el layout
        }
    }
    
    @IBInspectable var bottomColor:UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) {
        didSet { //teshta3'al abl mane3mel set le var
            self.setNeedsLayout() //2e3mel update le shakl el layout
        }
    }
    
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
    
    override func layoutSubviews() { //elly hatnafez el update
        let gredientLayer = CAGradientLayer()
        gredientLayer.colors = [topColor.cgColor , bottomColor.cgColor]//momken 2a3mel aktar men colour
        gredientLayer.startPoint = CGPoint(x: 0, y: 0)
        gredientLayer.endPoint = CGPoint(x: 1, y: 1)
        gredientLayer.frame = self.bounds //leta7ded size el gredient
        self.layer.insertSublayer(gredientLayer, at: 0)
    }
    
     // */
    
}
